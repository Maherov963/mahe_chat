import 'package:mahe_chat/app/pages/setting/setting_page.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/my_snackbar.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  double? containerHight = 0;
  late double w;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width * 0.9;
    return Drawer(
      width: w,
      child: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final auth = ref.watch(authProvider);
                final authRead = ref.read(authProvider.notifier);
                return ListView(
                  reverse: false,
                  children: [
                    UserAccountsDrawerHeader(
                      onDetailsPressed: () {
                        setState(() {
                          containerHight == 0
                              ? containerHight = 180
                              : containerHight = 0;
                        });
                      },
                      decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor),
                      accountName: Text(auth.myUser!.username!),
                      accountEmail: Text(auth.myUser!.phone!),
                      currentAccountPicture: GestureDetector(
                        onTap: () {},
                        child: Hero(
                          tag: 0,
                          child: ClipOval(
                            child: SizedBox.square(
                                dimension: 100,
                                child:
                                    Image.asset("assets/images/profile.png")),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        height: containerHight,
                        duration: const Duration(milliseconds: 100),
                        child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              // ListTile(
                              //   title: Text(auth.user1.getFullName),
                              //   trailing: const CircleAvatar(
                              //     radius: 14,
                              //     // backgroundColor: color3,
                              //     // foregroundColor: color6,
                              //     child: Text("16",
                              //         style: TextStyle(fontSize: 12)),
                              //   ),
                              //   onTap: () async {
                              //     Navigator.pop(context);
                              //     authRead.getStoredAccount();
                              //   },
                              // ),
                              // ListTile(
                              //   title: Text(auth.user2.getFullName),
                              //   trailing: const CircleAvatar(
                              //     radius: 14,
                              //     // backgroundColor: color3,
                              //     // foregroundColor: color6,
                              //     child: Text("16",
                              //         style: TextStyle(fontSize: 12)),
                              //   ),
                              //   onTap: () async {
                              //     Navigator.pop(context);

                              //     authRead.setUser2();
                              //   },
                              // ),

                              ListTile(
                                title: const Text("Add Account"),
                                leading: const Icon(Icons.add),
                                onTap: () {},
                              ),
                              const Divider(color: Colors.grey),
                            ])),
                    ListTile(
                      title: const Text('Settings'),
                      leading: const Icon(
                        Icons.settings,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        MyRouter.myPush(context, const SettingPage());
                      },
                    ),
                    ListTile(
                      title: const Text('Help'),
                      leading: const Icon(
                        Icons.help_center,
                      ),
                      onTap: () async {
                        // MyRouter.myPush(context, GameWidget(game: MyGame()));
                      },
                    ),
                    ListTile(
                      title: const Text('Meheral Game'),
                      leading: const Icon(Icons.gamepad_outlined),
                      onTap: () async {
                        // MyRouter.myPush(context, const MeheralLuancher());
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(
              Icons.logout,
            ),
            subtitle: const Text('Logging out this account from this device'),
            onTap: () async {
              MySnackBar.showYesNoDialog(
                  context, "Are you sure you want to Log out?");
            },
          ),
        ],
      ),
    );
  }
}
