import 'package:mahe_chat/app/pages/setting/setting_page.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int selectedIndex = 0;
  final List _langs = ["on", "off", "system defult"];
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dark Mode"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: getTitle("Dark mode", ctx),
          ),
          Expanded(
            child: ListView.separated(
                itemCount: _langs.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: getListTitle(_langs[index]),
                    groupValue: selectedIndex,
                    value: index,
                    onChanged: (val) {
                      setState(() {
                        selectedIndex = val!;
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

Widget getTitle(String title, BuildContext ctx) => Text(
      title,
      style: TextStyle(
        color: Theme.of(ctx).colorScheme.primaryContainer,
        fontWeight: FontWeight.bold,
      ),
    );
