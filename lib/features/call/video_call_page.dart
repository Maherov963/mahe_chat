import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mahe_chat/features/call/signaling.dart';

class CallPage extends StatefulWidget {
  final String userId;

  const CallPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final TextEditingController _roomIdController = TextEditingController();

  Signaling signaling = Signaling();
  bool _inCall = false;
  String? _currentRoomId;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    signaling.onLocalStream = (stream) => _localRenderer.srcObject = stream;
    signaling.onAddRemoteStream =
        (stream) => _remoteRenderer.srcObject = stream;
    signaling.onRemoveRemoteStream = () => _remoteRenderer.srcObject = null;
    signaling.onDisconnect = () {
      setState(() {
        _inCall = false;
        _currentRoomId = null;
      });
    };

    signaling.listenForIncomingCalls(widget.userId);
    signaling.onIncomingCall = (callerId, roomId) async {
      final accept = await _showIncomingCallDialog(callerId);
      if (accept) {
        await signaling.answerCall(roomId);
        setState(() {
          _inCall = true;
          _currentRoomId = roomId;
        });
      } else {
        await signaling.rejectCall(roomId);
      }
    };
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  Future<bool> _showIncomingCallDialog(String callerId) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Incoming Call'),
            content: Text('Call from $callerId'),
            actions: [
              TextButton(
                child: Text('Decline'),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                child: Text('Accept'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Page'),
      ),
      body: _inCall ? _buildCallUI() : _buildIdleUI(),
      floatingActionButton: _inCall
          ? FloatingActionButton(
              onPressed: () async {
                await signaling.hungUp();
                setState(() {
                  _inCall = false;
                  _currentRoomId = null;
                });
              },
              child: Icon(Icons.call_end),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }

  Widget _buildIdleUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Create Room'),
            onPressed: () async {
              final calleeId = await _showTextInputDialog('Enter callee ID:');
              if (calleeId == null || calleeId.isEmpty) return;

              await signaling.callUser(widget.userId, calleeId);
              setState(() {
                _inCall = true;
                _currentRoomId = signaling.roomId;
              });

              _showRoomDialog(signaling.roomId!);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.login),
            label: Text('Join Room'),
            onPressed: () async {
              final roomId =
                  await _showTextInputDialog('Enter Room ID to join:');
              if (roomId == null || roomId.isEmpty) return;

              await signaling.joinRoomById(roomId);
              setState(() {
                _inCall = true;
                _currentRoomId = roomId;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCallUI() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: RTCVideoView(_remoteRenderer),
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          width: 120,
          height: 160,
          child: Container(
            decoration: BoxDecoration(color: Colors.black54),
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
        ),
      ],
    );
  }

  Future<void> _showRoomDialog(String roomId) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Room Created'),
        content: Row(
          children: [
            Expanded(
              child: Text(
                roomId,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: roomId));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Room ID copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(String label) async {
    _roomIdController.clear();
    return await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: _roomIdController,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context, _roomIdController.text),
          ),
        ],
      ),
    );
  }
}
