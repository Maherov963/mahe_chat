import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:mahe_chat/app/utils/widgets/my_popup_menu.dart';
import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../../components/certified_account.dart';
import '../../components/icon_text_c_button.dart';
import '../setting/setting_page.dart';
import 'my_sliver_abbbar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _mute = false;
  bool _locked = false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final color10 = Theme.of(context).cardColor;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          UserProfileAppBar(
            scrollController: _scrollController,
            file: AssetImg.mine,
            certified: true,
            firstLastName: "maher ghieh",
            actions: [
              MyPopUpMenu(
                list: [
                  MyPopUpMenu.getWithIcon(
                    "Share contact",
                    Icons.adaptive.share,
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const CertifiedAccount(
                  name: "maher ghieh",
                  certified: true,
                  fontSize: 18,
                ),
                const Text("+963 937 915 453", style: TextStyle(fontSize: 18)),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconTextCButton(text: "Message", icon: Icons.chat),
                      IconTextCButton(text: "Call", icon: Icons.call),
                      IconTextCButton(text: "Save", icon: Icons.person_add),
                    ],
                  ),
                ),
                const Divider(
                  // color: colorDarker,
                  thickness: 10,
                  endIndent: 0,
                  indent: 0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: getTitle("Bio"),
                    ),
                    ListTile(
                      title: getListTitle(
                          "Some times you have to sacrifice your king in order to win the game"),
                      subtitle: getSubTitle(DateTime.now().getYYYYMMDD()),
                    ),
                    const Divider(
                      // color: colorDarker,
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: getTitle("Information"),
                    ),
                    ListTile(
                      title: getListTitle("Phone Number"),
                      subtitle: getSubTitle("+963 937 915 453"),
                      leading: const Icon(Icons.contact_phone),
                      onTap: () {},
                    ),
                    ListTile(
                      title: getListTitle("username"),
                      subtitle: getSubTitle("@maherov"),
                      leading: const Icon(Icons.alternate_email),
                      onTap: () {},
                    ),
                    ListTile(
                      title: getListTitle("email"),
                      subtitle: getSubTitle("maherghi123@gmail.com"),
                      leading: const Icon(Icons.email),
                      onTap: () {},
                    ),
                    const Divider(
                      // color: colorDarker,
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    ListTile(
                      title: getSubTitle("Media , documents and Links"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {},
                    ),
                    const Divider(
                      // color: colorDarker,
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    SwitchListTile(
                      value: _mute,
                      // activeColor: color3,
                      title: getListTitle("Mute notifications"),
                      secondary: const Icon(Icons.volume_off_rounded),
                      onChanged: (val) {
                        setState(() {
                          _mute = !_mute;
                        });
                      },
                    ),
                    SwitchListTile(
                      value: _locked,
                      // activeColor: color3,
                      title: getListTitle("Lock chat"),
                      secondary: const Icon(Icons.lock),
                      onChanged: (val) {
                        setState(() {
                          _locked = !_locked;
                        });
                      },
                    ),
                    const Divider(
                      // color: colorDarker,
                      thickness: 10,
                      endIndent: 0,
                      indent: 0,
                    ),
                    ListTile(
                      title: getListTitle("Block this user", color: color10),
                      leading: const Icon(Icons.block),
                      onTap: () {},
                    ),
                    ListTile(
                      title: getListTitle("Report this user", color: color10),
                      leading: const Icon(Icons.thumb_down),
                      onTap: () {},
                    ),
                  ],
                ),
                Container(
                  // color: colorDarker,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTitle(String title) => Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
}
