// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemMessageAdapter extends TypeAdapter<SystemMessage> {
  @override
  final int typeId = 6;

  @override
  SystemMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemMessage(
      author: fields[0] as Profile,
      createdAt: fields[1] as DateTime?,
      id: fields[2] as String,
      metadata: (fields[3] as Map?)?.cast<String, dynamic>(),
      remoteId: fields[4] as int?,
      replyPreview: fields[5] as ReplyPreview?,
      roomId: fields[6] as int?,
      showStatus: fields[7] as bool?,
      status: fields[8] as Status?,
      text: fields[12] as String,
      type: fields[9] as MessageType?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SystemMessage obj) {
    writer
      ..writeByte(12)
      ..writeByte(12)
      ..write(obj.text)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.metadata)
      ..writeByte(4)
      ..write(obj.remoteId)
      ..writeByte(5)
      ..write(obj.replyPreview)
      ..writeByte(6)
      ..write(obj.roomId)
      ..writeByte(7)
      ..write(obj.showStatus)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemMessage _$SystemMessageFromJson(Map<String, dynamic> json) =>
    SystemMessage(
      author: json['author'] == null
          ? const Profile(id: "1")
          : Profile.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      remoteId: (json['remoteId'] as num?)?.toInt(),
      replyPreview: json['replyPreview'] == null
          ? null
          : ReplyPreview.fromJson(json['replyPreview'] as Map<String, dynamic>),
      roomId: (json['roomId'] as num?)?.toInt(),
      showStatus: json['showStatus'] as bool?,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.sending,
      text: json['text'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SystemMessageToJson(SystemMessage instance) =>
    <String, dynamic>{
      'author': instance.author,
      'createdAt': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'replyPreview': instance.replyPreview,
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'status': _$StatusEnumMap[instance.status],
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'text': instance.text,
    };

const _$StatusEnumMap = {
  Status.delivered: 'delivered',
  Status.error: 'error',
  Status.seen: 'seen',
  Status.sending: 'sending',
  Status.sent: 'sent',
};

const _$MessageTypeEnumMap = {
  MessageType.audio: 'audio',
  MessageType.custom: 'custom',
  MessageType.file: 'file',
  MessageType.image: 'image',
  MessageType.system: 'system',
  MessageType.text: 'text',
  MessageType.unsupported: 'unsupported',
  MessageType.video: 'video',
};
