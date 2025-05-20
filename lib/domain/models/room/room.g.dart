// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final int typeId = 5;

  @override
  Room read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      createdAt: fields[0] as DateTime?,
      id: fields[1] as int,
      imageUrl: fields[2] as String?,
      lastMessages: (fields[3] as List?)?.cast<Message>(),
      name: fields[4] as String?,
      type: fields[5] as RoomType?,
      updatedAt: fields[6] as DateTime?,
      users: (fields[7] as List).cast<Profile>(),
    );
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.lastMessages)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomTypeAdapter extends TypeAdapter<RoomType> {
  @override
  final int typeId = 7;

  @override
  RoomType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoomType.channel;
      case 1:
        return RoomType.direct;
      case 2:
        return RoomType.group;
      default:
        return RoomType.channel;
    }
  }

  @override
  void write(BinaryWriter writer, RoomType obj) {
    switch (obj) {
      case RoomType.channel:
        writer.writeByte(0);
        break;
      case RoomType.direct:
        writer.writeByte(1);
        break;
      case RoomType.group:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: (json['id'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      lastMessages: (json['lastMessages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      type: $enumDecodeNullable(_$RoomTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      users: (json['users'] as List<dynamic>)
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'lastMessages': instance.lastMessages,
      'name': instance.name,
      'type': _$RoomTypeEnumMap[instance.type],
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'users': instance.users,
    };

const _$RoomTypeEnumMap = {
  RoomType.channel: 'channel',
  RoomType.direct: 'direct',
  RoomType.group: 'group',
};
