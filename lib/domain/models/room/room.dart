import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

/// All possible room types.
@HiveType(typeId: 7)
enum RoomType {
  @HiveField(0)
  channel,
  @HiveField(1)
  direct,
  @HiveField(2)
  group,
}

@HiveType(typeId: 5)
@JsonSerializable()
abstract class Room extends HiveObject {
  Room._({
    this.createdAt,
    required this.id,
    this.imageUrl,
    this.lastMessages,
    this.name,
    required this.type,
    this.updatedAt,
    required this.users,
  });

  factory Room({
    DateTime? createdAt,
    required int id,
    String? imageUrl,
    List<Message>? lastMessages,
    String? name,
    required RoomType? type,
    DateTime? updatedAt,
    required List<Profile> users,
  }) = _Room;

  /// Creates room from a map (decoded JSON).
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  @HiveField(0)
  final DateTime? createdAt;
  @HiveField(1)
  final int id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  @HiveField(2)
  final String? imageUrl;
  @HiveField(3)
  final List<Message>? lastMessages;
  @HiveField(4)
  final String? name;
  @HiveField(5)
  final RoomType? type;
  @HiveField(6)
  final DateTime? updatedAt;
  @HiveField(7)
  final List<Profile> users;

  Room copyWith({
    DateTime? createdAt,
    int? id,
    String? imageUrl,
    List<Message>? lastMessages,
    String? name,
    RoomType? type,
    DateTime? updatedAt,
    List<Profile>? users,
  });

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

/// A utility class to enable better copyWith.
class _Room extends Room {
  _Room({
    super.createdAt,
    required super.id,
    super.imageUrl,
    super.lastMessages,
    super.name,
    required super.type,
    super.updatedAt,
    required super.users,
  }) : super._();

  @override
  Room copyWith({
    dynamic createdAt = _Unset,
    int? id,
    dynamic imageUrl = _Unset,
    dynamic lastMessages = _Unset,
    dynamic metadata = _Unset,
    dynamic name = _Unset,
    dynamic type = _Unset,
    dynamic updatedAt = _Unset,
    List<Profile>? users,
  }) =>
      _Room(
        createdAt: createdAt == _Unset ? this.createdAt : createdAt,
        id: id ?? this.id,
        imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl,
        lastMessages: lastMessages == _Unset ? this.lastMessages : lastMessages,
        name: name == _Unset ? this.name : name,
        type: type == _Unset ? this.type : type,
        updatedAt: updatedAt == _Unset ? DateTime.now() : updatedAt,
        users: users ?? this.users,
      );
}

class _Unset {}
