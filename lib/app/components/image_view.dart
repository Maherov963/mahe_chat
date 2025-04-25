import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MyImageView extends StatefulWidget {
  final String? link;
  final String? name;
  const MyImageView({super.key, this.link, this.tag = 0, required this.name});
  final dynamic tag;
  @override
  State<MyImageView> createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {
  bool isShown = true;
  bool isZoomed = false;
  PhotoViewController photoViewController = PhotoViewController();
  @override
  void initState() {
    photoViewController.outputStateStream.listen((event) {
      if (event.scale == 0.58) {
        if (isZoomed) {
          isZoomed = false;
          setState(() {});
        }
      } else {
        if (!isZoomed) {
          isZoomed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      direction: DismissiblePageDismissDirection.vertical,
      onDismissed: () => Navigator.of(context).pop(),
      key: const Key("imageViewer"),
      disabled: true,
      child: buildBody(),
    );
  }

  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  isShown = !isShown;
                });
              },
              child: Hero(
                tag: widget.tag,
                child: PhotoView(
                  initialScale: 0.58,
                  minScale: 0.58,
                  controller: photoViewController,
                  imageProvider: const AssetImage(AssetImg.mine),
                ),
              )),
          if (isShown)
            Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(5),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Expanded(
                          child: Text(
                        widget.name ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
