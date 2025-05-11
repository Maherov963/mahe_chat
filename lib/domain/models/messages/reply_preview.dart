import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'reply_preview.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class ReplyPreview {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String senderName;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final int? senderId;
  const ReplyPreview({
    required this.id,
    required this.senderName,
    required this.text,
    required this.senderId,
  });

  factory ReplyPreview.fromJson(Map<String, dynamic> json) =>
      _$ReplyPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyPreviewToJson(this);
}
