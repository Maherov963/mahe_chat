import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? roomId;
  String? userId;

  final Map<String, dynamic> _configurationServer = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ]
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": false, // ✅ لا فيديو
    },
    "optional": [],
  };

  late RTCPeerConnection _rtcPeerConnection;
  late MediaStream _localStream;

  late Function(MediaStream stream) onLocalStream;
  late Function(MediaStream stream) onAddRemoteStream;
  late Function() onRemoveRemoteStream;
  late Function() onDisconnect;
  late Function(String callerId, String roomId) onIncomingCall;

  void listenForIncomingCalls(String id) {
    userId = id;
    db
        .collection('rooms')
        .where('calleeId', isEqualTo: userId)
        .where('callStatus', isEqualTo: 'ringing')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        onIncomingCall.call(data['callerId'], doc.id);
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
    onLocalStream.call(_localStream);

    _rtcPeerConnection = await createPeerConnection(_configurationServer);
    registerPeerConnectionListeners();

    _localStream.getTracks().forEach((track) {
      _rtcPeerConnection.addTrack(track, _localStream);
    });

    final callerCandidates = roomRef.collection('callerCandidates');
    _rtcPeerConnection.onIceCandidate = (candidate) {
      if (candidate != null) {
        callerCandidates.add(candidate.toMap());
      }
    };

    _rtcPeerConnection.onTrack = (event) {
      onAddRemoteStream.call(event.streams[0]);
    };

    final offer = await _rtcPeerConnection.createOffer(offerSdpConstraints);
    await _rtcPeerConnection.setLocalDescription(offer);
    await roomRef.update({'offer': offer.toMap()});

    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data == null) return;

      if (data.containsKey('answer')) {
        final answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );
        await _rtcPeerConnection.setRemoteDescription(answer);
      } else if (data['callStatus'] == 'declined') {
        await hungUp();
      }
    });

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          _rtcPeerConnection.addCandidate(RTCIceCandidate(
            data?['candidate'],
            data?['sdpMid'],
            data?['sdpMlineIndex'],
          ));
        }
      }
    });
  }

  Future<void> joinRoomById(String roomId) async {
    await answerCall(roomId);
  }

  Future<void> answerCall(String roomId) async {
    this.roomId = roomId;
    final roomRef = db.collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();
    final roomData = roomSnapshot.data();

    if (roomData == null || roomData['offer'] == null) {
      print('Offer not available.');
      return;
    }

    await roomRef.update({'callStatus': 'accepted'});

    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
    onLocalStream.call(_localStream);

    _rtcPeerConnection = await createPeerConnection(_configurationServer);
    registerPeerConnectionListeners();

    _localStream.getTracks().forEach((track) {
      _rtcPeerConnection.addTrack(track, _localStream);
    });

    _rtcPeerConnection.onTrack = (event) {
      onAddRemoteStream.call(event.streams[0]);
    };

    final calleeCandidates = roomRef.collection('calleeCandidates');
    _rtcPeerConnection.onIceCandidate = (candidate) {
      if (candidate != null) {
        calleeCandidates.add(candidate.toMap());
      }
    };

    final offer = roomData['offer'];
    await _rtcPeerConnection.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );

    final answer = await _rtcPeerConnection.createAnswer(offerSdpConstraints);
    await _rtcPeerConnection.setLocalDescription(answer);
    await roomRef.update({'answer': answer.toMap()});

    roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          _rtcPeerConnection.addCandidate(RTCIceCandidate(
            data?['candidate'],
            data?['sdpMid'],
            data?['sdpMlineIndex'],
          ));
        }
      }
    });
  }

  Future<void> rejectCall(String roomId) async {
    await db.collection('rooms').doc(roomId).update({'callStatus': 'declined'});
  }

  void muteMic() {
    final track = _localStream.getAudioTracks().first;
    track.enabled = !track.enabled;
  }

  Future<void> hungUp() async {
    _localStream.getTracks().forEach((track) => track.stop());
    onRemoveRemoteStream();
    await _rtcPeerConnection.close();

    if (roomId != null) {
      final roomRef = db.collection('rooms').doc(roomId);
      final calleeCandidates =
          await roomRef.collection('calleeCandidates').get();
      final callerCandidates =
          await roomRef.collection('callerCandidates').get();

      for (var doc in calleeCandidates.docs) {
        await doc.reference.delete();
      }
      for (var doc in callerCandidates.docs) {
        await doc.reference.delete();
      }

      await roomRef.delete();
    }
  }

  void registerPeerConnectionListeners() {
    _rtcPeerConnection.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        hungUp();
        onDisconnect();
      }
    };
  }
}
