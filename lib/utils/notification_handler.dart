import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? soundFilePath;
  String? title = message.notification!.title;
  logCyan("NOTIF TITLE ::: $title");

  switch(title!.trim()){
    case 'New Meeting Request!':
      soundFilePath = 'magicmarimba';
      break;
    case 'Meeting approved!':
      soundFilePath = 'positive';
      break;
    case 'Logout Notification':
      soundFilePath = 'negative';
      await MobileHomeViewController().logoutAndDeleteUserData();
      break;
    default:
      soundFilePath = 'default_notification';
      break;
  }

  logCyan("NOTIF SOUND CHOICE ::: $soundFilePath");

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'nexttipushservice',
        'nextti push service',
        channelDescription: 'default nextti push service',
        importance: Importance.max,
        priority: Priority.max,
        visibility: NotificationVisibility.public,
        icon: 'mipmap/ic_launcher',
        enableVibration: true,
        enableLights: true,
        styleInformation: const DefaultStyleInformation(true, true),
        playSound: true,
        ledColor: Colors.deepPurple,
        largeIcon: const DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        colorized: true, ledOffMs: 1000, ledOnMs: 1000,
        channelShowBadge: const bool.fromEnvironment('channelShowBadge', defaultValue: true),
        sound: RawResourceAndroidNotificationSound(soundFilePath)
      );
      
  RemoteNotification? notification = message.notification;
  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,    
    notification!.title,
    notification.body,
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const DarwinNotificationDetails()),
  ).catchError((onError)=> logRed(onError.toString()));
  // AudioPlayer audioPlayer = AudioPlayer();
  // if (message.notification!.title! == 'Meeting canceled!'){
  //   await audioPlayer.play(AssetSource('negative.wav'));
  // }else if (message.notification!.title! == 'Meeting approved!'){
  //   await audioPlayer.play(AssetSource('positive.wav'));
  // } else {
  //   await audioPlayer.play(AssetSource('default_notification.wav'));
  // }
  unreadNotificationCount.value++;
  logCyan('Handling a background message ${message.data['body']}');
}