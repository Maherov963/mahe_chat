import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, this.body, this.appBar});
  final Widget? body;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("value"),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: appBar,
        body: body,
      ),
    );
  }
}
