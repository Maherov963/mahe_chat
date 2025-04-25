import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/system_message.dart';
import 'package:mahe_chat/domain/models/room/room.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

class HiveDb {
  HiveDb._();
  static final HiveDb _instance = HiveDb._();
  static HiveDb get instance => _instance;
  static String cPath = "";
  Future<void> init({String? path}) async {
    final appDocumentDirectory =
        path ?? (await path_provider.getApplicationDocumentsDirectory()).path;
    cPath = appDocumentDirectory;
    Hive.init(appDocumentDirectory);
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(RoomAdapter());
    Hive.registerAdapter(TextMessageAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(SystemMessageAdapter());
    Hive.registerAdapter(StatusAdapter());
    Hive.registerAdapter(RoomTypeAdapter());
  }

  Future<void> close() async {
    return await Hive.close();
  }
}
