// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_preview.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReplyPreviewAdapter extends TypeAdapter<ReplyPreview> {
  @override
  final int typeId = 8;

  @override
  ReplyPreview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReplyPreview(
      id: fields[0] as String,
      senderName: fields[1] as String,
      text: fields[2] as String,
      senderId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReplyPreview obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderName)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.senderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyPreviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyPreview _$ReplyPreviewFromJson(Map<String, dynamic> json) => ReplyPreview(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      senderId: (json['senderId'] as String),
    );

Map<String, dynamic> _$ReplyPreviewToJson(ReplyPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderName': instance.senderName,
      'text': instance.text,
      'senderId': instance.senderId,
    };
