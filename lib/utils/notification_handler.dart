import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_logout_and_delete_user_data.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? soundFilePath;
  String? title = message.notification!.title;
  AudioPlayer audioPlayer = AudioPlayer();
  logCyan("NOTIF TITLE ::: $title");

  switch(title!.trim()){
    case 'New Meeting Request!':
      await audioPlayer.play(AssetSource('sounds/magicmarimba.wav'));
      break;
    case 'Meeting approved!':
      await audioPlayer.play(AssetSource('sounds/positive.wav'));
      break;
    case 'Logout':
      await audioPlayer.play(AssetSource('sounds/negative.wav'));
      OnLogoutAndDeleteUserData();
      break;
    default:
      await audioPlayer.play(AssetSource('sounds/default_notification.wav'));
      break;
  }

  logCyan("NOTIF SOUND CHOICE ::: $soundFilePath");

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'portospacepushservice',
        'portospace push service',
        channelDescription: 'default portospace push service',
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
  unreadNotificationCount.value++;
  logCyan('Handling a background message ${message.data['body']}');
}