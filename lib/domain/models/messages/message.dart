import 'package:mahe_chat/domain/models/messages/text_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:hive/hive.dart';

import 'reply_preview.dart';
export 'text_message.dart';
part 'message.g.dart';

abstract class Message extends HiveObject {
  Message({
    required this.author,
    this.createdAt,
    required this.id,
    this.metadata,
    this.remoteId,
    this.replyPreview,
    this.roomId,
    this.showStatus,
    this.status = Status.sending,
    required this.type,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final type = MessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MessageType.unsupported,
    );

    switch (type) {
      // case MessageType.audio:
      //   return AudioMessage.fromJson(json);
      // case MessageType.custom:
      //   return CustomMessage.fromJson(json);
      // case MessageType.file:
      //   return FileMessage.fromJson(json);
      // case MessageType.image:
      //   return ImageMessage.fromJson(json);
      // case MessageType.system:
      //   return SystemMessage.fromJson(json);
      case MessageType.text:
        return TextMessage.fromJson(json);
      // case MessageType.unsupported:
      //   return UnsupportedMessage.fromJson(json);
      // case MessageType.video:
      //   return VideoMessage.fromJson(json);
      default:
        return TextMessage.fromJson(json);
    }
  }
  @HiveField(0)

  /// Profile who sent this message.
  final Profile author;
  @HiveField(1)

  /// Created message timestamp, in ms.
  final DateTime? createdAt;
  @HiveField(2)

  /// Unique ID of the message.
  final int id;
  @HiveField(3)

  /// Additional custom metadata or attributes related to the message.
  final Map<String, dynamic>? metadata;
  @HiveField(4)

  /// Unique ID of the message received from the backend.
  final int? remoteId;
  @HiveField(5)

  /// Message that is being replied to with the current message.
  final ReplyPreview? replyPreview;
  @HiveField(6)

  /// ID of the room where this message is sent.
  final int? roomId;
  @HiveField(7)

  /// Show status or not.
  final bool? showStatus;
  @HiveField(8)

  /// Message [Status].
  final Status? status;
  @HiveField(9)

  /// [MessageType].
  final MessageType type;
  @HiveField(10)

  /// Updated message timestamp, in ms.
  final DateTime? updatedAt;

  /// Converts a particular message to the map representation, serializable to JSON.
  Map<String, dynamic> toJson();
  ReplyPreview getPreivew();

  Message copyWith({
    Profile? author,
    DateTime? createdAt,
    int? id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    ReplyPreview? replyPreview,
    int? roomId,
    Status? status,
    DateTime? updatedAt,
  });
}

@HiveType(typeId: 2)
enum Status {
  @HiveField(0)
  delivered,
  @HiveField(1)
  error,
  @HiveField(2)
  seen,
  @HiveField(3)
  sending,
  @HiveField(4)
  sent;
}

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  audio,
  @HiveField(1)
  custom,
  @HiveField(2)
  file,
  @HiveField(3)
  image,
  @HiveField(4)
  system,
  @HiveField(5)
  text,
  @HiveField(6)
  unsupported,
  @HiveField(7)
  video;
}
