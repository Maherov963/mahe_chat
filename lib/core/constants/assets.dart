abstract class Assets {
  static Audio get audio => Audio();
  static Image get image => Image();
}

class Audio {
  final String move = "assets/audios/Move.mp3";
  final String capture = "assets/audios/Capture.mp3";
}

class Image {
  final String profile = "assets/images/profile.png";
}
