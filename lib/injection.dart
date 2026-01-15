import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'core/constants/storage_keys.dart';
import 'core/services/notification_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive boxes
  final messagesBox = await Hive.openBox(StorageKeys.messagesBox);
  final chatsBox = await Hive.openBox(StorageKeys.chatsBox);
  final usersBox = await Hive.openBox(StorageKeys.usersBox);
  final queuedMessagesBox = await Hive.openBox(StorageKeys.queuedMessagesBox);

  // Register external dependencies
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => const Uuid());
  getIt.registerLazySingleton(() => ImagePicker());

  // Register Firebase Messaging
  getIt.registerLazySingleton(() => FirebaseMessaging.instance);

  // Register Local Notifications
  getIt.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // Register Notification Service
  getIt.registerLazySingleton(() => NotificationService(
    getIt<FirebaseMessaging>(),
    getIt<FlutterLocalNotificationsPlugin>(),
  ));

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Register Hive boxes with named instances
  getIt.registerLazySingleton<Box<dynamic>>(
        () => messagesBox,
    instanceName: 'messagesBox',
  );
  getIt.registerLazySingleton<Box<dynamic>>(
        () => chatsBox,
    instanceName: 'chatsBox',
  );
  getIt.registerLazySingleton<Box<dynamic>>(
        () => usersBox,
    instanceName: 'usersBox',
  );
  getIt.registerLazySingleton<Box<dynamic>>(
        () => queuedMessagesBox,
    instanceName: 'queuedMessagesBox',
  );

  // Initialize injectable
  getIt.init();
}