import 'package:mahe_chat/app/mosque_system.dart';
import 'package:mahe_chat/data/datasources/local_db/hive_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> main() async {
  await initialize();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServer();
  await HiveDb.instance.init();
}

Future<void> initServer() async {
  const keyApplicationId = 'cGnR5gSRVLMXppoazutvD91xoiaHLeMv5m8z2K5y';
  const keyClientKey = '1xoL9230rcA547SqeGWTSOd2R0YDSrxQsdJB1Xr2';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
}
