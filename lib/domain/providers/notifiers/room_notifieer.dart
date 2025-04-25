import 'package:mahe_chat/data/datasources/local_db/rooms_db.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/room/room.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  List<Room> _rooms = [];
  final RoomDb _roomDb = RoomDb.instance;
  List<Room> get rooms => _sortRooms();

  int get nextId {
    return _rooms.isEmpty ? 0 : _rooms.first.id + 1;
  }

  _sortRooms() {
    final List<Room> list = List.from(_rooms);
    list.sort(
      (a, b) {
        return b.updatedAt!.compareTo(a.updatedAt!);
      },
    );
    return list;
  }

  getRooms() async {
    _rooms = await _roomDb.getRooms();
    notifyListeners();
  }

  editLastmessageRoom(Message message) async {
    final index = _rooms.indexWhere((e) => e.id == message.roomId);
    _rooms[index] = _rooms[index].copyWith(lastMessages: [message]);
    await _roomDb.editRoomLastMessage(message);
    notifyListeners();
  }

  addRoom() async {
    final newRoom = Room(
      id: nextId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      type: RoomType.direct,
      users: [],
      name: "room num$nextId",
    );
    _rooms.insert(0, newRoom);
    await _roomDb.addRoom(newRoom);
    notifyListeners();
  }

  deleteRoom(List<int> roomIds) {
    for (final id in roomIds) {
      _rooms.removeWhere((e) => e.id == id);
      _roomDb.deleteRoomById(id);
    }
    notifyListeners();
  }
}
