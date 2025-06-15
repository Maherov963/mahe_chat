// lib/signaling.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? roomId;
  String? userId;

  final _config = {
    'iceServers': [
      {
        'urls': ['stun:stun1.l.google.com:19302']
      }
    ],
    'sdpSemantics': 'unified-plan',
  };

  final _sdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  late RTCPeerConnection _peer;
  late MediaStream _localStream;

  // لربط الأحداث مع الواجهة
  late Function(MediaStream) onLocalStream;
  late Function(MediaStream) onAddRemoteStream;
  late Function() onRemoveRemoteStream;
  late Function() onDisconnect;
  late Function(String callerId, String roomId) onIncomingCall;

  void listenForCalls(String uid) {
    userId = uid;
    db
        .collection('rooms')
        .where('calleeId', isEqualTo: uid)
        .where('callStatus', isEqualTo: 'ringing')
        .snapshots()
        .listen((snap) {
      for (var doc in snap.docs) {
        final data = doc.data();
        onIncomingCall(data['callerId'], doc.id);
      }
    });
  }

  Future<void> callUser(String callerId, String calleeId) async {
    final roomRef = db.collection('rooms').doc();
    roomId = roomRef.id;

    await roomRef.set({
      'callerId': callerId,
      'calleeId': calleeId,
      'callStatus': 'ringing',
    });

    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
    onLocalStream(_localStream);

    _peer = await createPeerConnection(_config);
    _peer.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        hangUp();
        onDisconnect();
      }
    };

    _localStream.getTracks().forEach((t) => _peer.addTrack(t, _localStream));
    roomRef.collection('callerCandidates').snapshots().listen((snap) {
      for (var ch in snap.docChanges) {
        if (ch.type == DocumentChangeType.added) {
          final d = ch.doc.data()!;
          _peer.addCandidate(
              RTCIceCandidate(d['candidate'], d['sdpMid'], d['sdpMlineIndex']));
        }
      }
    });

    _peer.onIceCandidate = (c) {
      if (c != null) roomRef.collection('callerCandidates').add(c.toMap());
    };

    _peer.onTrack = (evt) {
      onAddRemoteStream(evt.streams[0]);
    };

    final offer = await _peer.createOffer(_sdpConstraints);
    await _peer.setLocalDescription(offer);
    await roomRef.update({'offer': offer.toMap()});

    roomRef.snapshots().listen((snap) {
      final d = snap.data();
      if (d == null) return;
      if (d.containsKey('answer')) {
        final ans =
            RTCSessionDescription(d['answer']['sdp'], d['answer']['type']);
        _peer.setRemoteDescription(ans);
      } else if (d['callStatus'] == 'declined') {
        hangUp();
      }
    });
  }

  Future<void> answerCall(String rid) async {
    roomId = rid;
    final roomRef = db.collection('rooms').doc(rid);
    final snap = await roomRef.get();
    final data = snap.data();
    if (data == null || !data.containsKey('offer')) return;

    await roomRef.update({'callStatus': 'accepted'});

    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
    onLocalStream(_localStream);

    _peer = await createPeerConnection(_config);
    _peer.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        hangUp();
        onDisconnect();
      }
    };

    _localStream.getTracks().forEach((t) => _peer.addTrack(t, _localStream));

    final offerMap = data['offer'];
    await _peer.setRemoteDescription(
      RTCSessionDescription(offerMap['sdp'], offerMap['type']),
    );

    _peer.onTrack = (evt) => onAddRemoteStream(evt.streams[0]);
    final calleeCandidates = roomRef.collection('calleeCandidates');
    _peer.onIceCandidate = (c) {
      if (c != null) calleeCandidates.add(c.toMap());
    };

    roomRef.collection('callerCandidates').snapshots().listen((snap) {
      for (var ch in snap.docChanges) {
        if (ch.type == DocumentChangeType.added) {
          final d = ch.doc.data()!;
          _peer.addCandidate(
              RTCIceCandidate(d['candidate'], d['sdpMid'], d['sdpMlineIndex']));
        }
      }
    });

    final answer = await _peer.createAnswer(_sdpConstraints);
    await _peer.setLocalDescription(answer);
    await roomRef.update({'answer': answer.toMap()});
  }

  Future<void> declineCall(String rid) async {
    await db.collection('rooms').doc(rid).update({'callStatus': 'declined'});
  }

  Future<void> hangUp() async {
    _localStream.getTracks().forEach((t) => t.stop());
    onRemoveRemoteStream();
    await _peer.close();
    if (roomId != null) {
      final roomRef = db.collection('rooms').doc(roomId);
      final cols = await roomRef.collection('callerCandidates').get();
      final cles = await roomRef.collection('calleeCandidates').get();
      for (var d in [...cols.docs, ...cles.docs]) {
        await d.reference.delete();
      }
      await roomRef.delete();
      roomId = null;
    }
  }
}
