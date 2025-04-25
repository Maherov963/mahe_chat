import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'system_message.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class SystemMessage extends Message {
  SystemMessage({
    super.author = const User(id: 1),
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.system);

  factory SystemMessage.fromJson(Map<String, dynamic> json) =>
      _$SystemMessageFromJson(json);
  @HiveField(12)

  /// System message content (could be text or translation key).
  final String text;

  @override
  Map<String, dynamic> toJson() => _$SystemMessageToJson(this);

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
