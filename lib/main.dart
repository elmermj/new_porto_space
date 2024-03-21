import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_model.dart';
import 'package:new_porto_space/platforms/mobile_porto_space_app.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

RxString deviceToken = ''.obs;
RxBool isLogin = false.obs;
Rx<Box<dynamic>> isNewApp = Hive.box<dynamic>('isNewApp').obs;

void logRed(String msg) {
  debugPrint('\x1B[31m$msg\x1B[0m');
}

void logGreen(String msg) {
  debugPrint('\x1B[32m$msg\x1B[0m');
}

void logYellow(String msg) {
  debugPrint('\x1B[33m$msg\x1B[0m');
}

void logCyan(String msg) {
  debugPrint('\x1B[36m$msg\x1B[0m');
}

void logPink(String msg){
  debugPrint('\x1B[35m$msg\x1B[0m');
}

getNotificationToken() async {
  String? token;
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );
  if(Platform.isAndroid){
    token = await FirebaseMessaging.instance.getToken();
  }
  if(Platform.isIOS){
    token = await FirebaseMessaging.instance.getAPNSToken();
  }
  return token;
}

Future<void> requestPermissions() async {
  // Request permissions for camera, storage, microphone, etc.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
    Permission.microphone,
    Permission.contacts,
    Permission.location,
    Permission.phone,
    Permission.sms,
    Permission.notification,
    Permission.sensors,
    Permission.mediaLibrary,
    Permission.photos,
    Permission.storage,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
  ].request();
  
  if (statuses[Permission.camera] != PermissionStatus.granted ||
      statuses[Permission.storage] != PermissionStatus.granted ||
      statuses[Permission.microphone] != PermissionStatus.granted) {
    // Handle denied permissions
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Please grant all the required permissions to use this app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(ChatRoomModelAdapter());
  await Hive.openBox<User>('userData');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var user = await FirebaseAuth.instance.currentUser?.getIdToken();
  logYellow('User ID token: $user');

  isLogin.value = user?.isNotEmpty ?? false;

  deviceToken.value = await getNotificationToken();

  // Check if the app is new or not
  var isNewAppBox = await Hive.openBox<bool>('isNewApp');
  var box = isNewAppBox.get('new', defaultValue: true);
  bool isNewAppValue = box!;

  if(kIsWeb){
    logRed('Web is not supported yet');
    exit(1);
  } else {
    if(Platform.isAndroid || Platform.isIOS){     
      await requestPermissions(); 
      runApp(
        MobilePortoSpaceApp(
          isNewAppValue: isNewAppValue,
          isLoggedIn: isLogin.value,
        )
      );
    }
  } 
}