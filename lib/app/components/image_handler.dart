import 'dart:io';

import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:flutter/material.dart';

class ImageHandler extends StatelessWidget {
  final String? path;
  final bool isCircular;
  final BoxFit? fit;
  final double? width;
  final double? hight;
  final void Function()? onTap;
  const ImageHandler({
    super.key,
    required this.path,
    this.fit,
    this.isCircular = true,
    this.width,
    this.hight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCircular) {
      return ClipOval(
        child: GestureDetector(
          onTap: onTap,
          child: buildImage(),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: buildImage(),
      );
    }
  }

  Widget buildImage() {
    if (path == null) {
      return Image.asset(
        AssetImg.profile,
        width: width,
        height: hight,
        fit: fit,
      );
    } else if (path?.startsWith("http") ?? false) {
      return Image.network(
        path!,
        width: width,
        height: hight,
        fit: fit,
      );
    } else if (path?.startsWith("assets") ?? false) {
      return Image.asset(
        path!,
        width: width,
        height: hight,
        fit: fit,
      );
    } else {
      return Image.file(
        File(path!),
        width: width,
        height: hight,
        fit: fit,
      );
    }
  }
}
