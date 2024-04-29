import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_porto_space/adapters/chat_room_model_adapter.dart';
import 'package:new_porto_space/adapters/friend_model_adapter.dart';
import 'package:new_porto_space/adapters/timestamp_adapter.dart';
import 'package:new_porto_space/adapters/user_account_model_adapter.dart';
import 'package:new_porto_space/firebase_options.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/notification/on_message.dart';
import 'package:new_porto_space/notification/on_message_opened.dart';
import 'package:new_porto_space/notification/firebase_messaging_background_handler.dart';

backgroundNotificationInitialization() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(UserAccountModelAdapter());
  Hive.registerAdapter(ChatRoomModelAdapter());
  Hive.registerAdapter(FriendModelAdapter());
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
  
  onMessage();

  onMessageOpened();
  
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

  currentFCMToken.value = await getNotificationToken();

}