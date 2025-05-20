import 'dart:io';
import 'package:mahe_chat/app/components/certified_account.dart';
import 'package:mahe_chat/app/components/chat_input/chat_input_area.dart';
import 'package:mahe_chat/app/components/image_handler.dart';
import 'package:mahe_chat/app/components/my_snackbar.dart';
import 'package:mahe_chat/app/pages/chat_page/chat.dart';
import 'package:mahe_chat/app/pages/profile/user_profile.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:mahe_chat/app/utils/plugins/my_photo_picker.dart';
import 'package:mahe_chat/domain/models/room/room.dart';
import 'package:mahe_chat/domain/providers/notifiers/chat_provider.dart';
import 'package:mahe_chat/app/utils/widgets/my_popup_menu.dart';
import 'package:mahe_chat/domain/models/messages/audio_message.dart';
import 'package:mahe_chat/domain/models/messages/file_message.dart';
import 'package:mahe_chat/domain/models/messages/image_message.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/features/music.dart';
import 'package:open_filex/open_filex.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatPage extends ConsumerStatefulWidget {
  final Room room;
  final Profile user;
  const ChatPage({
    super.key,
    required this.user,
    required this.room,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final FocusNode focusNode = FocusNode();
  // final MyPhotoPicker _myPhotoPicker = MyPhotoPicker();
  final AutoScrollController itemScrollController = AutoScrollController();

  Message? replyMessage;

  void _handleSendPressed(String text) {
    final textMessage = TextMessage(
      text: text,
      author: widget.user,
      createdAt: DateTime.now(),
      id: ref.read(chatProvider).nextId,
      replyPreview: replyMessage?.getPreivew(),
      roomId: widget.room.id,
    );
    _addMessage(textMessage);
  }

  void _handleSendRecord(
    Duration duration,
    num size,
    String uri,
  ) {
    final textMessage = AudioMessage(
      duration: duration,
      name: "Record",
      size: size,
      uri: uri,
      author: widget.user,
      createdAt: DateTime.now(),
      id: ref.read(chatProvider).nextId,
      replyPreview: replyMessage?.getPreivew(),
    );

    _addMessage(textMessage);
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
      ref.read(chatProvider).addMessage(message, SendRecive.send);

      ref.read(roomProvider).editLastmessageRoom(message);
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
    if (message is FileMessage) {
      var localPath = message.uri;

      await OpenFilex.open(localPath);
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final select = ref.watch(messageSelectProvider);
    final selectRead = ref.read(messageSelectProvider.notifier);
    return PopScope(
      canPop: select.isEmpty,
      onPopInvoked: (didPop) {
        if (!didPop) {
          selectRead.removeAll();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: select.isEmpty ? getGeneralAppBar() : getSelectedAppBar(),
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
                    final chat = ref.watch(chatProvider);
                    return Expanded(
                      child: Chat(
                        controller: itemScrollController,
                        messages: chat.messages,
                        user: widget.user,
                        handleMessageTap:
                            select.isEmpty ? _handleMessageTap : null,
                        handleSwipe: select.isEmpty ? _handleSwipe : null,
                      ),
                    );
                  },
                ),
                RepaintBoundary(
                  child: ChatInputArea(
                    focusNode: focusNode,
                    reply: replyMessage,
                    currentUser: widget.user,
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
          ],
        ),
      ),
    );
  }

  getSelectedAppBar() {
    final select = ref.watch(messageSelectProvider);
    final selectRead = ref.read(messageSelectProvider.notifier);
    return AppBar(
      title: Text(select.length.toString()),
      actions: [
        MyPopUpMenu(
          list: [
            MyPopUpMenu.getWithIcon(
              "Info",
              Icons.info_outline,
              onTap: () {
                selectRead.removeAll();
              },
            ),
            MyPopUpMenu.getWithIcon(
              "Delete",
              Icons.delete,
              // color: color10,
              onTap: () {
                selectRead.removeAll();
                ref.read(chatProvider).deleteMessage(select);
              },
            ),
            if (select.length == 1)
              MyPopUpMenu.getWithIcon(
                "Copy",
                Icons.copy,
                onTap: () {
                  final message = ref
                      .read(chatProvider)
                      .messages
                      .whereType<Message>()
                      .firstWhere((e) => e.id == select.first) as TextMessage;
                  Clipboard.setData(ClipboardData(text: message.text));
                  selectRead.removeAll();
                },
              ),
            MyPopUpMenu.getWithIcon(
              "Reply",
              Icons.reply,
              onTap: () {
                selectRead.removeAll();
              },
            ),
          ],
        ),
      ],
      leading: IconButton(
        onPressed: () {
          selectRead.removeAll();
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  getGeneralAppBar() {
    final chat = ref.read(chatProvider);

    return AppBar(
      forceMaterialTransparency: true,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
        MyPopUpMenu(
          list: [
            PopupMenuItem(
              child: const Text("Clear chat"),
              onTap: () async {
                final state = await MySnackBar.showDeleteDialig(context);
                if (state && mounted) {
                  chat.deleteAllMessage(widget.room.id);
                }
              },
            ),
          ],
        ),
      ],
      title: InkWell(
        onTap: () {
          MyRouter.myPush(context, const UserProfile());
        },
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Consumer(
            builder: (context, ref, child) {
              final chatProv = ref.watch(chatProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CertifiedAccount(
                    name: widget.room.name ?? "",
                    fontSize: 18,
                    certified: true,
                    // color: Colors.white,
                  ),
                  if (chatProv.feedback != "")
                    Text(
                      chatProv.feedback,
                      style: const TextStyle(
                        fontSize: 12,
                        // color: Colors.white,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      titleSpacing: 0,
      leadingWidth: 66,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Row(
            children: [
              Icon(Icons.arrow_back),
              Expanded(child: ImageHandler(path: AssetImg.mine)),
            ],
          ),
        ),
      ),
    );
  }
}
