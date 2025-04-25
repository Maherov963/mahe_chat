// import 'package:mahe_chat/app/chessv3/pages/loopy.dart';
import 'package:mahe_chat/app/components/my_drawer.dart';
import 'package:mahe_chat/app/components/my_snackbar.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../chat_page/home_chat_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    // ref.read(authProvider).getStoredAccount();
    _tabController = TabController(
      length: 1,
      animationDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.index != 1) {
        ref.read(chatSelectProvider.notifier).removeAll();
      }
    });
    super.initState();
  }

  List<int> selected = [];
  @override
  Widget build(BuildContext context) {
    final chatprov = ref.watch(chatSelectProvider);
    return Scaffold(
      key: _key,
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            chatprov.isNotEmpty
                ? getSelectedAppBar(chatprov)
                : getGeneralAppBar(),
            getTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  HomeChatPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSelectedAppBar(List<int> chatprov) {
    final selectRead = ref.read(chatSelectProvider.notifier);
    final roomProv = ref.read(roomProvider.notifier);

    return AppBar(
      title: Text(chatprov.length.toString()),
      actions: [
        IconButton(
            onPressed: () async {
              final agreed = await MySnackBar.showDeleteDialig(context);
              if (agreed) {
                roomProv.deleteRoom(chatprov);
              }
              selectRead.removeAll();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ))
      ],
      leading: IconButton(
          onPressed: () {
            selectRead.removeAll();
          },
          icon: const Icon(Icons.arrow_back)),
    );
  }

  getTabBar() {
    return TabBar(
      dividerHeight: 0,
      splashBorderRadius: BorderRadius.circular(5),
      tabs: const [
        Tab(text: "Chats"),
      ],
      controller: _tabController,
    );
  }

  getGeneralAppBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SearchBar(
              trailing: const [Icon(Icons.search)],
              leading: IconButton(
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded)),
              hintText: "Alkhalil Chat",
            ),
          ),
        ),
      ],
    );
  }
}
