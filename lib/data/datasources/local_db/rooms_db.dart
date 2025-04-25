import 'package:mahe_chat/data/datasources/local_db/message_db.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/room/room.dart';
import 'package:hive/hive.dart';

class RoomDb {
  RoomDb._();
  static final RoomDb _instance = RoomDb._();
  static RoomDb get instance => _instance;
  final String _tableName = 'my_rooms';
  Box<Room>? _table;
  Future<void> openBox() async {
    _table = await Hive.openBox(_tableName);
  }

  Future<List<Room>> getRooms() async {
    if (_table == null) {
      await openBox();
    }
    return _table!.values.toList().reversed.toList();
  }

  Future<void> close() async {
    _table = null;
    await Hive.deleteBoxFromDisk(_tableName);
  }

  Room? getRoomByKey(dynamic key) {
    return _table?.get(key);
  }

  Future<void> deleteRoomById(dynamic key) async {
    await MessageDb.instance.clearInRoom(key);
    return await _table?.delete(key);
  }

  Future<void> addRoom(Room room) async {
    return await _table?.put(room.id, room);
  }

  Future<void> editRoomById(Room room) async {
    return await _table?.put(room.key, room);
  }

  Future<void> editRoomLastMessage(Message message) async {
    final newRoom =
        getRoomByKey(message.roomId)?.copyWith(lastMessages: [message]);
    return await _table?.put(message.roomId, newRoom!);
  }

  Future<void> clearRooms() async {
    await _table?.clear();
  }
}
