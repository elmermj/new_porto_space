import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:new_porto_space/adapters/timestamp_adapter.dart';
import 'package:new_porto_space/components/notification_snackbar.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_porto_space_app.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_logout_and_delete_user_data.dart';
import 'package:new_porto_space/utils/notification_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart' as rx;

import 'firebase_options.dart';

RxString deviceToken = ''.obs;
RxBool isLogin = false.obs;
Rx<Box<dynamic>> isNewApp = Hive.box<dynamic>('isNewApp').obs;
RxString currentFCMToken = ''.obs;
RxInt unreadNotificationCount = 0.obs;
final messageStreamController = rx.BehaviorSubject<RemoteMessage>();

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
    logRed('Permissions not granted');
    return;
  }
}

Rx<UserAccountModel> userData = UserAccountModel().obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAccountModelAdapter());
  Hive.registerAdapter(ChatRoomModelAdapter());
  Hive.registerAdapter(TimestampAdapter());
  await Hive.openBox<UserAccountModel>('userData');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  logYellow('User granted permission: ${settings.authorizationStatus}');
  
  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    currentFCMToken.value = (await messaging.getToken(
      vapidKey: 'BPRuylqqpLvuGDQpxZLxvojTaBEQYeBQP4Rg7_NPdkPD7Ro5s_hU6hJuF0lfohB28VLPTKj5Wr0etmwtxJDJR8g',
    ))!;
    logYellow('TOKEN: $currentFCMToken');
  } else {
    currentFCMToken.value = await getNotificationToken();
    logYellow('TOKEN: $currentFCMToken');
  }

  await FirebaseMessaging.instance.getInitialMessage();
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    logYellow('onMessage: $message');
    if (message.notification!.title!.isEmpty) {
      return;
    }
    logYellow("${message.notification!.title!} and ${message.notification!.body!}");
    AudioPlayer audioPlayer = AudioPlayer();
    if (message.notification!.title! == 'Logout'){
      await audioPlayer.play(AssetSource('sounds/negative.wav'));
      OnLogoutAndDeleteUserData;
      showLogoutWarningDialog(
        title: message.notification!.title!, 
        message: message.notification!.body!, 
        duration: const Duration(milliseconds: 1500)
      );
    }else if (message.notification!.title! == 'Meeting approved!'){
      await audioPlayer.play(AssetSource('sounds/positive.wav'));
    } else {
      await audioPlayer.play(AssetSource('sounds/default_notification.wav'));
    }

    
    logYellow("onMessage Data: ${message.notification!.title!}");
    showNotifcationSnackBar(
      title: message.notification!.title!, 
      message: message.notification!.body!, 
      duration: const Duration(milliseconds: 1500)
    );
    messageStreamController.sink.add(message);
    unreadNotificationCount.value++;
  });
  
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    logYellow('onMessageOpenedApp: $message');
    if (message.notification!.title!.isEmpty) {
      return;
    }
    AudioPlayer audioPlayer = AudioPlayer();

    await audioPlayer.play(AssetSource('sounds/default_notification.wav'));
    if (message.notification!.title! == 'Logout'){
      await audioPlayer.play(AssetSource('sounds/negative.wav'));
      OnLogoutAndDeleteUserData();
      showLogoutWarningDialog(
        title: message.notification!.title!, 
        message: message.notification!.body!, 
        duration: const Duration(milliseconds: 1500)
      );
    }

    showNotifcationSnackBar(
      title: message.notification!.title!, 
      message: message.notification!.body!, 
      duration: const Duration(milliseconds: 1500)
    );
    
    logYellow("onMessage Data: ${message.notification!.title!}");
    unreadNotificationCount.value++;
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  var user = await FirebaseAuth.instance.currentUser?.getIdToken();
  logYellow('User ID token: $user');
  if(user!= null){
    final userID = FirebaseAuth.instance.currentUser!.uid;
    userData.value = Hive.box<UserAccountModel>('userData').get("${userID}_accountData")!;
    logGreen("SUCCESS RETRIEVING DATA FROM LOCAL STORAGE");
    logGreen("msg: ${userData.value.name}");
    logGreen("DEVICE TOKEN : ${userData.value.deviceToken}");
    isLogin.value = true;
  }else{
    isLogin.value = false;
  }

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
      // await requestPermissions();
      runApp(
        MobilePortoSpaceApp(
          isNewAppValue: isNewAppValue,
          isLoggedIn: isLogin.value,
        )
      );
    }
  } 
}