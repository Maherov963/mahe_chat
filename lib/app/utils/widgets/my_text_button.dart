import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.onTap,
    this.onLongPressed,
    required this.text,
    this.color,
    this.fontSize = 14,
  });
  final void Function()? onTap;
  final void Function()? onLongPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(color?.withOpacity(0.5)),
      onTap: onTap,
      onLongPress: onLongPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? 14,
          ),
        ),
      ),
    );
  }
}
