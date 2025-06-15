import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:mahe_chat/domain/models/room/room.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:mahe_chat/domain/providers/notifiers/chat_provider.dart';
import 'package:mahe_chat/app/utils/widgets/my_popup_menu.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
import 'package:mahe_chat/features/call/signaling.dart';
import 'package:mahe_chat/features/chat/data/remote/chat_api.dart';
import 'package:mahe_chat/features/chat/domain/models/conversation.dart';
import 'package:mahe_chat/features/music.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../components/chat_input/chat_input_area.dart';

import 'chat.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String group_id;
  final Conversation? conversation;
  const ChatPage(
    this.group_id, {
    super.key,
    this.conversation,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final FocusNode focusNode = FocusNode();
  // final MyPhotoPicker _myPhotoPicker = MyPhotoPicker();
  final AutoScrollController itemScrollController = AutoScrollController();

  Message? replyMessage;

  Future<List<String>> getConversationMembers(String conversationId) async {
    final doc = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['members'] != null) {
        return List<String>.from(data['members']);
      }
    }

    return [];
  }

  void _handleSendPressed(String text) async {
    // final textMessage = TextMessage(
    //   text: text,
    //   author: widget.user,
    //   createdAt: DateTime.now(),
    //   id: ref.read(chatProvider).nextId,
    //   replyPreview: replyMessage?.getPreivew(),
    //   roomId: widget.room.id,
    // );
    // _addMessage(textMessage);
    await ChatApi().addMessageToConversation(
        conversationId: "IR8Gc31xKVmrG1NXGAuO", messageText: text);
  }

  void _handleSendRecord(
    Duration duration,
    num size,
    String uri,
  ) {
    // final textMessage = AudioMessage(
    //   duration: duration,
    //   name: "Record",
    //   size: size,
    //   uri: uri,
    //   author: widget.user,
    //   createdAt: DateTime.now(),
    //   id: ref.read(chatProvider).nextId,
    //   replyPreview: replyMessage?.getPreivew(),
    // );

    // _addMessage(textMessage);
  }

  void _handleFileSelection() async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );

    // if (result != null && result.files.single.path != null) {
    //   final message = FileMessage(
    //     author: widget.user,
    //     createdAt: DateTime.now(),
    //     id: ref.read(chatProvider).nextId,
    //     // mimeType: lookupMimeType(result.files.single.path!),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: result.files.single.path!,
    //   );
    //   // mySocketHandler
    //   //     .sendFile(File(result.files.single.path!).readAsBytesSync());

    //   _addMessage(message);
    // }
  }

  void _addMessage(Message message) {
    setState(() {
      replyMessage = null;
      // ref.read(chatProvider).addMessage(message, SendRecive.send);

      // ref.read(roomProvider).editLastmessageRoom(message);
    });
  }

  void _handleSwipe(Message repMessage) {
    setState(() {
      replyMessage = repMessage;
      // if (!focusNode.hasFocus) {

      // FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(focusNode);
      // }
    });
  }

  void _handleMessageTap(Message message) async {
    // if (message is FileMessage) {
    //   var localPath = message.uri;

    //   await OpenFilex.open(localPath);
    // }
  }

  void _handleGalleryTap() async {
    // final path = await _myPhotoPicker.fromGallery();
    // if (path != null) {
    //   final size = File(path).lengthSync();
    //   final image = await decodeImageFromList(File(path).readAsBytesSync());
    //   final message = ImageMessage(
    //     author: widget.user,
    //     createdAt: DateTime.now(),
    //     id: ref.read(chatProvider).nextId,
    //     name: "pic",
    //     width: image.width.toDouble(),
    //     height: image.height.toDouble(),
    //     size: size,
    //     uri: path,
    //     repliedMessage: replyMessage,
    //   );
    //   _addMessage(message);
    // }
  }
  bool isCallAnswered = false;
  bool isWaitingForAnswer = false;
  Signaling? _signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  BuildContext? _callingDialogContext;

  @override
  void initState() {
    super.initState();
    _initRenderers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).myUser!;
      _signaling = Signaling()
        ..onLocalStream = (stream) {
          _localRenderer.srcObject = stream;
        }
        ..onAddRemoteStream = (stream) {
          _remoteRenderer.srcObject = stream;
          _closeCallingDialog(); // ✅ أغلق نافذة الانتظار عندما يتم الرد
          _showCallScreen(); // ✅ افتح شاشة المكالمة
        }
        ..onRemoveRemoteStream = () {
          _remoteRenderer.srcObject = null;
        }
        ..onDisconnect = () {
          _closeCallingDialog();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Call disconnected')),
          );
        }
        ..onIncomingCall = (callerId, roomId) {
          _showIncomingCallDialog(callerId, roomId); // ✅ الآن ستعمل
        }
        ..listenForCalls(user.id!);
    });
  }

  void _showCallingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        _callingDialogContext = ctx;
        return AlertDialog(
          title: Text('Calling...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Waiting for the other user to answer...'),
            ],
          ),
        );
      },
    );
  }

  void _closeCallingDialog() {
    if (_callingDialogContext != null) {
      Navigator.of(_callingDialogContext!).pop();
      _callingDialogContext = null;
    }
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _showIncomingCallDialog(String callerId, String rid) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Incoming Call'),
          content: Text('User $callerId is calling you.'),
          actions: [
            TextButton(
                onPressed: () {
                  _signaling?.declineCall(rid);
                  Navigator.of(context).pop();
                },
                child: Text('Decline')),
            ElevatedButton(
                onPressed: () {
                  _signaling?.answerCall(rid);
                  Navigator.of(context).pop();
                  _showCallScreen();
                },
                child: Text('Accept')),
          ],
        );
      },
    );
  }

  void _showCallScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Voice Call')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_localRenderer.srcObject != null) Text('You are in a call'),
            ElevatedButton(
              onPressed: () {
                _signaling?.hangUp();
                Navigator.of(context).pop();
              },
              child: Text('Hang Up'),
            ),
          ],
        ),
      );
    }));
  }

  void _startCall() {
    final user = ref.read(authProvider).myUser!;
    final myId = user.id;

    final otherProfile = widget.conversation!.participants!.firstWhere(
      (profile) => profile.id != myId,
      orElse: () => Profile(id: null),
    );

    final otherId = otherProfile.id;
    if (otherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يوجد مستخدم آخر للمكالمة.')),
      );
      return;
    }

    _signaling?.callUser(myId!, otherId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCallingDialog();
    });
  }

  void _showWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isCallAnswered ? "متصل" : "جارٍ الاتصال..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isCallAnswered
                    ? Text("تم الرد على المكالمة")
                    : CircularProgressIndicator(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _signaling?.hangUp();
                  Navigator.of(context).pop();
                },
                child: Text("إلغاء"),
              ),
            ],
          );
        });
      },
    );
  }

  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  AppBar get _appBar => AppBar(
        title: Text(widget.conversation?.name ?? "Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: _startCall,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final select = ref.watch(messageSelectProvider);
    final user = ref.read(authProvider).myUser;
    // final selectRead = ref.read(messageSelectProvider.notifier);
    // Call the function to get the stream
    final conversationStream =
        ChatApi().getMessagesStream(widget.conversation!.id!);

    // Check if the stream is empty (user not logged in case)
    if (conversationStream == Stream.empty()) {
      // Return a widget indicating the user needs to log in or similar
      return Scaffold(
        appBar: _appBar,
        body: Center(
          child: Text('Please log in to see your conversations.'),
        ),
      );
    }
    return PopScope(
      // canPop: select.isEmpty,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // selectRead.removeAll();
        }
      },
      child: Scaffold(
        appBar: _appBar,
        resizeToAvoidBottomInset: false,
        // appBar: select.isEmpty ? getGeneralAppBar() : getSelectedAppBar(),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ColorFiltered(
              colorFilter: theme.brightness == Brightness.dark
                  ? ColorFilter.mode(
                      theme.primaryColor,
                      BlendMode.color,
                    )
                  : ColorFilter.mode(
                      theme.scaffoldBackgroundColor,
                      BlendMode.difference,
                    ),
              child: Image.asset(
                'assets/images/chat_dark_back.jpg',
                filterQuality: FilterQuality.none,
                repeat: ImageRepeat.repeat,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    // final chat = ref.watch(chatProvider);
                    return Expanded(
                      child: StreamBuilder<List<Message>?>(
                          stream: conversationStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              // Handle error state
                              print(
                                  'Error listening to conversations: ${snapshot.error}');
                              return Center(
                                  child: Text(
                                      'Something went wrong: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Handle loading state while waiting for the first data
                              return Center(child: CircularProgressIndicator());
                            }

                            // --- Data is available! ---

                            // Check if there are no conversations yet
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text(
                                      'No conversations found. Start a new one!'));
                            }

                            // We have data, build the list of conversations
                            final messages = snapshot.data!;

                            return Chat(
                              controller: itemScrollController,
                              messages: messages,
                              user: user!,
                              handleMessageTap:
                                  // select.isEmpty ? _handleMessageTap :
                                  null,
                              handleSwipe:
                                  //  select.isEmpty ? _handleSwipe :
                                  null,
                            );
                          }),
                    );
                  },
                ),
                RepaintBoundary(
                  child: ChatInputArea(
                    focusNode: focusNode,
                    reply: replyMessage,
                    currentUser: user!,
                    onCloseReply: () {
                      setState(() {
                        replyMessage = null;
                      });
                    },
                    onMicPressed: () {},
                    onAudioAttach: () {
                      MyRouter.myPush(context, Songs());
                    },
                    onSendText: _handleSendPressed,
                    onRecordSendd: _handleSendRecord,
                  ),
                )
              ],
            ),
            if (_remoteRenderer.srcObject != null)
              Positioned(
                bottom: 100,
                left: 20,
                child:
                    CircleAvatar(child: Icon(Icons.call, color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  getSelectedAppBar() {
    // final select = ref.watch(messageSelectProvider);
    // final selectRead = ref.read(messageSelectProvider.notifier);
    // return AppBar(
    //   title: Text(select.length.toString()),
    //   actions: [
    //     MyPopUpMenu(
    //       list: [
    //         MyPopUpMenu.getWithIcon(
    //           "Info",
    //           Icons.info_outline,
    //           onTap: () {
    //             selectRead.removeAll();
    //           },
    //         ),
    //         MyPopUpMenu.getWithIcon(
    //           "Delete",
    //           Icons.delete,
    //           // color: color10,
    //           onTap: () {
    //             selectRead.removeAll();
    //             ref.read(chatProvider).deleteMessage(select);
    //           },
    //         ),
    //         if (select.length == 1)
    //           MyPopUpMenu.getWithIcon(
    //             "Copy",
    //             Icons.copy,
    //             onTap: () {
    //               final message = ref
    //                   .read(chatProvider)
    //                   .messages
    //                   .whereType<Message>()
    //                   .firstWhere((e) => e.id == select.first) as TextMessage;
    //               Clipboard.setData(ClipboardData(text: message.text));
    //               selectRead.removeAll();
    //             },
    //           ),
    //         MyPopUpMenu.getWithIcon(
    //           "Reply",
    //           Icons.reply,
    //           onTap: () {
    //             selectRead.removeAll();
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    //   leading: IconButton(
    //     onPressed: () {
    //       selectRead.removeAll();
    //     },
    //     icon: const Icon(Icons.arrow_back),
    //   ),
    // );
  }

  getGeneralAppBar() {
    // final chat = ref.read(chatProvider);

    // return AppBar(
    //   forceMaterialTransparency: true,
    //   actions: [
    //     IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
    //     MyPopUpMenu(
    //       list: [
    //         PopupMenuItem(
    //           child: const Text("Clear chat"),
    //           onTap: () async {
    //             // final state = await MySnackBar.showDeleteDialig(context);
    //             // if (state && mounted) {
    //             //   chat.deleteAllMessage(widget.room.id);
    //             // }
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    //   title: InkWell(
    //     onTap: () {
    //       // MyRouter.myPush(context, const UserProfile());
    //     },
    //     child: SizedBox(
    //       width: double.infinity,
    //       height: 50,
    //       child: Consumer(
    //         builder: (context, ref, child) {
    //           final chatProv = ref.watch(chatProvider);
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               CertifiedAccount(
    //                 name: widget.conversation?.name ?? "",
    //                 fontSize: 18,
    //                 certified: true,
    //                 // color: Colors.white,
    //               ),
    //               if (chatProv.feedback != "")
    //                 Text(
    //                   chatProv.feedback,
    //                   style: const TextStyle(
    //                     fontSize: 12,
    //                     // color: Colors.white,
    //                   ),
    //                 ),
    //             ],
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    //   titleSpacing: 0,
    //   leadingWidth: 66,
    //   leading: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.pop(context);
    //       },
    //       customBorder:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //       child: const Row(
    //         children: [
    //           Icon(Icons.arrow_back),
    //           Expanded(child: ImageHandler(path: AssetImg.mine)),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
