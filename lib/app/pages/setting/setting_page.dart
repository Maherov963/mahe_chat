import 'package:mahe_chat/app/components/my_scaffold.dart';
import 'package:mahe_chat/app/pages/setting/language_page.dart';
import 'package:mahe_chat/app/pages/setting/theme_page.dart';
import 'package:mahe_chat/app/router/router.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).appBarTheme.foregroundColor),
              ),
              expandedTitleScale: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: getTitle("Account"),
                    ),
                    ListTile(
                      title: getListTitle("phone number"),
                      subtitle: getSubTitle("+963 937 915 453"),
                      leading: const Icon(Icons.call),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Profile Name"),
                      subtitle: getSubTitle("Maherov"),
                      leading: const Icon(Icons.account_circle),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Bio"),
                      subtitle: getSubTitle("null"),
                      leading: const Icon(Icons.more),
                      onTap: () {},
                    ),
                    const Divider(
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: getTitle("Settings"),
                    ),
                    ListTile(
                      title: getListTitle("Chat settings"),
                      leading: const Icon(Icons.chat_bubble),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Night Mode"),
                      leading: const Icon(Icons.dark_mode),
                      onTap: () {
                        MyRouter.myPush(context, const ThemePage());
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Privacy and security"),
                      leading: const Icon(Icons.security),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Notifications and sounds"),
                      leading: const Icon(Icons.notifications_active),
                      onTap: () {
                        // AwesomeNotifications().showNotificationConfigPage();
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Data and storage"),
                      leading: const Icon(Icons.data_saver_off_rounded),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Language"),
                      subtitle: getSubTitle("System default"),
                      leading: const Icon(Icons.language),
                      onTap: () {
                        MyRouter.myPush(context, const LanguagePage());
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Linked Devices"),
                      leading: const Icon(Icons.devices),
                      onTap: () {},
                    ),
                    const Divider(
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: getTitle("Help"),
                    ),
                    ListTile(
                      title: getListTitle("Ask us"),
                      leading: const Icon(Icons.support_agent),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Rate the app"),
                      leading:
                          const Icon(Icons.sentiment_satisfied_alt_rounded),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: getListTitle("Privacy Policy"),
                      leading: const Icon(Icons.policy_rounded),
                      onTap: () {},
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: getSubTitle(
                            "Al khalil app for Android v1.0.0 (1) store bundled arm64-v8a"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitle(String title) => Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer,
          fontWeight: FontWeight.bold,
        ),
      );
}

Widget getListTitle(String title, {Color? color}) => Text(
      title,
      style: TextStyle(
        color: color ?? Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
Widget getSubTitle(String title) => Text(
      title,
      style: const TextStyle(
        fontSize: 12,
      ),
    );
