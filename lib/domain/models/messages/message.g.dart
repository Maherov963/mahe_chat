// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 2;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.delivered;
      case 1:
        return Status.error;
      case 2:
        return Status.seen;
      case 3:
        return Status.sending;
      case 4:
        return Status.sent;
      default:
        return Status.delivered;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.delivered:
        writer.writeByte(0);
        break;
      case Status.error:
        writer.writeByte(1);
        break;
      case Status.seen:
        writer.writeByte(2);
        break;
      case Status.sending:
        writer.writeByte(3);
        break;
      case Status.sent:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 3;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.audio;
      case 1:
        return MessageType.custom;
      case 2:
        return MessageType.file;
      case 3:
        return MessageType.image;
      case 4:
        return MessageType.system;
      case 5:
        return MessageType.text;
      case 6:
        return MessageType.unsupported;
      case 7:
        return MessageType.video;
      default:
        return MessageType.audio;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.audio:
        writer.writeByte(0);
        break;
      case MessageType.custom:
        writer.writeByte(1);
        break;
      case MessageType.file:
        writer.writeByte(2);
        break;
      case MessageType.image:
        writer.writeByte(3);
        break;
      case MessageType.system:
        writer.writeByte(4);
        break;
      case MessageType.text:
        writer.writeByte(5);
        break;
      case MessageType.unsupported:
        writer.writeByte(6);
        break;
      case MessageType.video:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
