import 'package:mahe_chat/domain/providers/notifiers/language_notifier.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/my_scaffold.dart';
import 'setting_page.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List _langs = ["العربية", "English", "France"];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text("Language"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: getTitle("Language"),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final lang = ref.watch(languageProvider);
              return ListView.separated(
                itemCount: _langs.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return RadioListTile<LanguageState>(
                    title: getListTitle(_langs[index]),
                    groupValue: lang,
                    value: LanguageState.values[index],
                    onChanged: (val) {
                      ref.read(languageProvider.notifier).setLanguage(val!);
                    },
                  );
                },
              );
            }),
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
