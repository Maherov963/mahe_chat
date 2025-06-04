import 'package:mahe_chat/app/pages/chat_page/chat_page.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

class HomeChatPage extends ConsumerStatefulWidget {
  const HomeChatPage({super.key});

  @override
  HomeChatPageState createState() => HomeChatPageState();
}

class HomeChatPageState extends ConsumerState<HomeChatPage> {
  bool isRef = false;
  @override
  void initState() {
    ref.read(roomProvider).getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProv = ref.watch(chatSelectProvider);
    final roomProv = ref.watch(roomProvider);
    final roomProvRead = ref.read(roomProvider.notifier);
    final selectedProvRead = ref.read(chatSelectProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (selectedProv.isEmpty) {
          return true;
        }
        selectedProvRead.removeAll();
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            roomProvRead.addRoom();
            // mySocketHandler.createRoom(
            //   onMessageRecieved: (p0) {
            //     ref.read(chatProvider).addMessage(
            //         Message.fromJson(
            //           jsonDecode(p0),
            //         ),
            //         SendRecive.send);
            //   },
            // ).then((value) {
            //   MyRouter.myPush(
            //     context,
            //     ChatPage(
            //       room: Room(
            //         id: 0,
            //         type: RoomType.group,
            //         users: [],
            //         name: mySocketHandler.ip,
            //       ),
            //       user: ref.read(authProvider.notifier).myUser!,
            //     ),
            //   );
            // });
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
        body: isRef
            ? const CircularProgressIndicator()
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  isRef = true;
                  setState(() {});

                  // mySocketHandler.refresh().then((value) {
                  //   setState(() {});
                  //   isRef = false;
                  // });
                },
                child: ListView.separated(
                  // itemCount: mySocketHandler.availableRooms.length,
                  itemCount: roomProv.rooms.length,
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: 0.1, height: 0),
                  itemBuilder: (context, index) => ListTile(
                    splashColor: Colors.transparent,
                    // selected: selectedProv.contains(roomsProv.rooms[index].id),
                    selectedTileColor: Theme.of(context).focusColor,
                    selectedColor: Colors.white,
                    leading: const ImageHandler(
                      path: AssetImg.mine,
                      width: 50,
                    ),
                    title: Text(roomProv.rooms[index].name ?? ""),
                    subtitle:
                        getLastMessage(roomProv.rooms[index].lastMessages),
                    onTap: () async {
                      await ref
                          .read(chatProvider)
                          .getChat(roomProv.rooms[index].id);
                      // mySocketHandler.joinRoom(
                      //   ip: mySocketHandler.availableRooms[index],
                      //   onMessageRecieved: (p0) {
                      //     ref.read(chatProvider).addMessage(
                      //         Message.fromJson(
                      //           jsonDecode(p0),
                      //         ),
                      //         SendRecive.send);
                      //   },
                      // );
                      if (context.mounted) {
                        MyRouter.myPush(
                          context,
                          ChatPage(
                            room: roomProv.rooms[index],
                            user: ref.read(authProvider.notifier).myUser!,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Widget? getLastMessage(List<Message>? lastMessages) {
    if (lastMessages?.isNotEmpty ?? false) {
      final message = (lastMessages!.first as TextMessage);
      return Text(
        "${message.author.username}: ${message.text}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return null;
    }
  }

  Widget getLastMessageTime(List<Message>? lastMessages) {
    if (lastMessages?.isNotEmpty ?? false) {
      final time = intl.DateFormat(intl.DateFormat.HOUR_MINUTE)
          .format(lastMessages!.first.createdAt ?? DateTime(1970));
      return Text(time);
    } else {
      return const Text("");
    }
  }
}

class MyDialog extends StatelessWidget {
  const MyDialog({super.key, required this.tag});
  final Object tag;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Material(
            // color: color1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
                maxWidth: 250,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Hero(
                            tag: tag,
                            child: ImageHandler(
                              path: AssetImg.mine,
                              isCircular: false,
                              onTap: () {
                                Navigator.pop(context);
                                context.pushTransparentRoute(MyImageView(
                                  name: "maher ghieh",
                                  tag: tag,
                                ));
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            color: Colors.black.withOpacity(0.3),
                            width: double.infinity,
                            child: const Row(
                              children: [
                                Expanded(
                                  child: CertifiedAccount(
                                    name: "Maherov ghieh",
                                    certified: true,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chat,
                            // color: color4,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call,
                            // color: color4,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            MyRouter.myPush(context, const UserProfile());
                          },
                          icon: const Icon(
                            Icons.info_outline,
                            // color: color4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
