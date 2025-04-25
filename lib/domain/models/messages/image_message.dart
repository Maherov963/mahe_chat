import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

class ImageMessage extends Message {
  /// Creates an image message.
  ImageMessage({
    required super.author,
    super.createdAt,
    this.height,
    this.description,
    required super.id,
    super.metadata,
    required this.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    MessageType? type,
    super.updatedAt,
    required this.uri,
    this.width,
  }) : super(type: type ?? MessageType.image);

  /// Creates an image message from a map (decoded JSON).
  // factory ImageMessage.fromJson(Map<String, dynamic> json) =>
  //     _$ImageMessageFromJson(json);

  final double? height;

  final String name;

  final num size;

  final String uri;

  final double? width;

  final String? description;

  @override
  Map<String, dynamic> toJson() => {};

  @override
  Message copyWith({
    User? author,
    DateTime? createdAt,
    int? id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    Message? repliedMessage,
    int? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    DateTime? updatedAt,
  }) {
    return this;
  }
}
