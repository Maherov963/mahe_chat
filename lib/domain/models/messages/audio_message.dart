import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/reply_preview.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

class AudioMessage extends Message {
  AudioMessage({
    required super.author,
    super.createdAt,
    required this.duration,
    required super.id,
    super.metadata,
    this.mediaType,
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
    this.waveForm,
  }) : super(type: type ?? MessageType.audio);

  // factory AudioMessage.fromJson(Map<String, dynamic> json) =>
  //     _$AudioMessageFromJson(json);

  /// The length of the audio.
  final Duration duration;

  /// Media type of the audio file.
  final String? mediaType;

  /// The name of the audio.
  final String name;

  /// Size of the audio in bytes.
  final num size;

  /// The audio file source (either a remote URL or a local resource).
  final String uri;

  /// Wave form represented as a list of decibel levels.
  final List<double>? waveForm;

  @override
  Map<String, dynamic> toJson() => {};

  @override
  Message copyWith({
    Profile? author,
    DateTime? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    ReplyPreview? replyPreview,
    int? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    DateTime? updatedAt,
  }) {
    return this;
  }

  @override
  ReplyPreview getPreivew() {
    return ReplyPreview(
      id: id,
      senderId: author.id,
      senderName: author.username!,
      text: name,
    );
  }
}
