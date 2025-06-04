import 'package:mahe_chat/app/utils/widgets/my_text_button.dart';
import 'package:flutter/material.dart';

import 'star_paint.dart';

class CertifiedAccount extends StatelessWidget {
  const CertifiedAccount({
    super.key,
    required this.name,
    this.certified = false,
    this.fontSize,
    this.color,
    this.onTap,
  });
  final String name;
  final bool certified;
  final double? fontSize;
  final Color? color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextButton(
            onTap: null,
            text: name,
            fontSize: fontSize,
            color: color,
          ),
          if (certified)
            ClipPath(
              clipper: StarClipper(12),
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.all(3),
                child: const Icon(
                  Icons.done_outlined,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
