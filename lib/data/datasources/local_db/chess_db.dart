import 'package:hive/hive.dart';

class ChessDb {
  ChessDb._();
  static final ChessDb _instance = ChessDb._();
  static ChessDb get instance => _instance;
  final String _tableName = 'chess_db';
  Box<int>? _table;
  Future<void> openBox() async {
    _table = await Hive.openBox(_tableName);
  }

  Future<List<int>> getChess() async {
    if (_table == null) {
      await openBox();
    }
    return _table!.values.toList();
  }

  Future<void> close() async {
    _table = null;
    await Hive.deleteBoxFromDisk(_tableName);
  }

  int? getRoomByKey(dynamic key) {
    return _table?.get(key);
  }

  Future<int?> addRoom(int room) async {
    return await _table?.add(room);
  }

  Future<void> clearRooms() async {
    await _table?.clear();
  }
}
