import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:hive/hive.dart';

class MessageDb {
  MessageDb._();
  static final MessageDb _instance = MessageDb._();
  static MessageDb get instance => _instance;
  final String tableName = 'my_messages';

  List<Box<Message>> tables = [];

  Future<void> openBox(int roomId) async {
    if (Hive.isBoxOpen("$tableName$roomId")) {
      return;
    }
    tables.add(await Hive.openBox("$tableName$roomId"));
    return;
  }

  Future<Message?> getMessageById(Message message) async {
    final table = await getTable(message.roomId!);
    return table.get(message.key);
  }

  Future<void> deleteMessageById(Message message) async {
    final table = await getTable(message.roomId!);
    return await table.delete(message.key);
  }

  Future<void> addMessage(Message message) async {
    final table = await getTable(message.roomId!);
    return await table.put(message.id, message);
  }

  Future<void> editMessage(Message message) async {
    final table = await getTable(message.roomId!);
    return await table.put(message.key, message);
  }

  Future<void> clearInRoom(int roomId) async {
    final table = await getTable(roomId);
    tables.remove(table);
    await table.clear();
  }

  Future<List<Message>> getMessagesInRoom(int roomId) async {
    final table = await getTable(roomId);
    return table.values.toList();
  }

  Future<Box<Message>> getTable(int roomId) async {
    await openBox(roomId);
    return tables.firstWhere((element) => element.name == "$tableName$roomId");
  }
}
