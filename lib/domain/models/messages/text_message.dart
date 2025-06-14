import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'reply_preview.dart';
part 'text_message.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
abstract class TextMessage extends Message {
  TextMessage._({
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.replyPreview,
    super.roomId,
    super.showStatus,
    super.status,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.text);

  factory TextMessage({
    required Profile author,
    DateTime? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    ReplyPreview? replyPreview,
    int? roomId,
    bool? showStatus,
    Status? status,
    required String text,
    MessageType? type,
    DateTime? updatedAt,
  }) = _TextMessage;

  @HiveField(11)
  final String text;

  factory TextMessage.fromJson(Map<String, dynamic> json) =>
      _$TextMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextMessageToJson(this);

  @override
  Message copyWith({
    Profile? author,
    DateTime? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    int? repliedMessageId,
    ReplyPreview? replyPreview,
    int? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    DateTime? updatedAt,
  });
}

/// A utility class to enable better copyWith.
class _TextMessage extends TextMessage {
  _TextMessage({
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.replyPreview,
    super.roomId,
    super.showStatus,
    super.status,
    required super.text,
    super.type,
    super.updatedAt,
  }) : super._();

  @override
  Message copyWith({
    dynamic author = _Unset,
    dynamic createdAt = _Unset,
    String? id,
    dynamic metadata = _Unset,
    dynamic previewData = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessageId = _Unset,
    dynamic replyPreview = _Unset,
    dynamic roomId = _Unset,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    String? text,
    dynamic updatedAt = _Unset,
  }) =>
      _TextMessage(
        author: author == _Unset ? this.author : author,
        createdAt: createdAt == _Unset ? this.createdAt : createdAt,
        id: id ?? this.id,
        metadata: metadata == _Unset ? this.metadata : metadata,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId,
        replyPreview: replyPreview == _Unset ? this.replyPreview : replyPreview,
        roomId: roomId == _Unset ? this.roomId : roomId,
        showStatus: showStatus == _Unset ? this.showStatus : showStatus,
        status: status == _Unset ? this.status : status,
        text: text ?? this.text,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt,
      );

  @override
  ReplyPreview getPreivew() {
    return ReplyPreview(
      senderId: author.id,
      id: id,
      senderName: author.username!,
      text: text,
    );
  }
}

class _Unset {}
