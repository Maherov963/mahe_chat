<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
<<<<<<< HEAD
=======
import 'package:cloud_firestore/cloud_firestore.dart';
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
import 'package:firebase_core/firebase_core.dart';
import 'package:mahe_chat/app/mosque_system.dart';
import 'package:mahe_chat/data/datasources/local_db/hive_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/firebase_options.dart';

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
<<<<<<< HEAD
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable offline persistence with cache size
  FirebaseFirestore.instance.settings.persistenceEnabled;
=======
<<<<<<< HEAD
  // const keyApplicationId = 'cGnR5gSRVLMXppoazutvD91xoiaHLeMv5m8z2K5y';
  // const keyClientKey = '1xoL9230rcA547SqeGWTSOd2R0YDSrxQsdJB1Xr2';
  // const keyParseServerUrl = 'https://parseapi.back4app.com';
  // await Parse().initialize(keyApplicationId, keyParseServerUrl,
  //     clientKey: keyClientKey, debug: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
=======
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable offline persistence with cache size
  FirebaseFirestore.instance.settings.persistenceEnabled;
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
}
