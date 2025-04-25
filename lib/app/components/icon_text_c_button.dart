import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:flutter/material.dart';

class IconTextCButton extends StatelessWidget {
  const IconTextCButton({
    super.key,
    this.text,
    this.onTap,
    required this.icon,
    this.color = Colors.grey,
  });
  final String? text;
  final void Function()? onTap;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      overlayColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      splashFactory: InkRipple.splashFactory,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            if (text != null) 10.getHightSizedBox,
            if (text != null)
              Text(
                text!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
