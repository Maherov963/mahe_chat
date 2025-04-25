import 'package:flutter/material.dart';

class MyAttacheSheet extends StatelessWidget {
  const MyAttacheSheet({
    super.key,
    this.handleFile,
    this.handleAudioFile,
    this.handleCameraFile,
    this.handleGalleryFile,
    this.handleClose,
  });
  final void Function()? handleFile;
  final void Function()? handleAudioFile;
  final void Function()? handleCameraFile;
  final void Function()? handleGalleryFile;
  final void Function()? handleClose;
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 30,
      ),
      children: [
        MyFilledIconText(
          text: "Audio File",
          color: const Color.fromARGB(255, 51, 255, 0),
          icon: Icons.headphones,
          onPressed: () {
            handleClose?.call();
            handleAudioFile?.call();
          },
        ),
        MyFilledIconText(
          text: "Camera",
          color: Colors.red,
          icon: Icons.camera_alt_rounded,
          onPressed: () {
            handleClose?.call();
            handleAudioFile?.call();
          },
        ),
        MyFilledIconText(
          text: "File",
          color: Colors.purple,
          icon: Icons.description,
          onPressed: () {
            handleClose?.call();
            handleFile?.call();
          },
        ),
        MyFilledIconText(
          text: "Gallery",
          color: Colors.pinkAccent,
          icon: Icons.collections_outlined,
          onPressed: () {
            handleClose?.call();
            handleGalleryFile?.call();
          },
        ),
      ],
    );
  }
}

class MyFilledIconText extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final void Function()? onPressed;
  const MyFilledIconText({
    super.key,
    required this.color,
    required this.icon,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      overlayColor: WidgetStatePropertyAll(color.withOpacity(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: RadialGradient(
                  colors: [
                    color,
                    color.withOpacity(0.5),
                  ],
                )),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}
