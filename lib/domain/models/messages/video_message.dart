import 'package:mahe_chat/domain/models/messages/message.dart';

abstract class VideoMessage extends Message {
  VideoMessage({
    required super.author,
    super.createdAt,
    this.height,
    required super.id,
    super.metadata,
    required this.name,
    super.remoteId,
    super.replyPreview,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    MessageType? type,
    super.updatedAt,
    required this.uri,
    this.width,
  }) : super(type: type ?? MessageType.video);

  /// Creates a video message from a map (decoded JSON).
  // factory VideoMessage.fromJson(Map<String, dynamic> json) =>
  //     _$VideoMessageFromJson(json);

  /// Video height in pixels.
  final double? height;

  /// The name of the video.
  final String name;

  /// Size of the video in bytes.
  final num size;

  /// The video source (either a remote URL or a local resource).
  final String uri;

  /// Video width in pixels.
  final double? width;

  /// Converts an video message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {};
}
