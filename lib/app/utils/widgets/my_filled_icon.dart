import 'package:flutter/material.dart';

class MyFilledIcon extends StatelessWidget {
  const MyFilledIcon({
    super.key,
    this.onTap,
    this.size = 16,
    this.fillColor,
    this.color = Colors.white,
    required this.icon,
  });
  final void Function()? onTap;
  final Color? fillColor;
  final Color? color;
  final double? size;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: size,
            color: color,
          ),
        ),
      ),
    );
  }
}
