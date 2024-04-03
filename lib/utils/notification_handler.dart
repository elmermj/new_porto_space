import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    case 'Call':
      final body = message.notification!.body!;
      final fallbackToken = message.data['fallbackToken'];
      final channelName = message.data['channelName'];
      final requesterName = message.data['requesterName'];
      logYellow("$body || $fallbackToken || $channelName || $requesterName");
      startIncomingCallActivity(body, channelName, requesterName, fallbackToken);
      // Get.to(
      //   () => MobileIncomingCallView(key: Get.key, message: body,),
      //   arguments: [
      //     channelName,
      //     requesterName,
      //     fallbackToken,
      //     true
      //   ]
      // );
      // showIncomingCallUI(channelName: channelName, requesterName: requesterName, fallbackToken: fallbackToken);
      // await incomingCallMain(message);
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
      
  RemoteNotification notification = message.notification!;
  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const DarwinNotificationDetails()),
  ).catchError((onError)=> logRed(onError.toString()));
  unreadNotificationCount.value++;
  logCyan('Handling a background message ${message.notification!.body}');
}


const MethodChannel _channel = MethodChannel("incoming_call_channel");

Future<void> startIncomingCallActivity(String body, String channelName, String requesterName, String fallbackToken) async {
  try {
    await _channel.invokeMethod('startIncomingCallActivity', {
      'body': body,
      'channelName': channelName,
      'requesterName': requesterName,
      'fallbackToken': fallbackToken,
    });
  } on Exception catch (e) {
    logRed(e.toString());
  }
}

// Call the native method to display incoming call UI
// void showIncomingCallUI({required String channelName, required String requesterName, required String fallbackToken}) {
//   const MethodChannel methodChannel = MethodChannel('com.example.new_porto_space/incoming_call_channel');
//   try {
//     methodChannel.invokeMethod('launchIncomingCallActivity', jsonEncode({
//       'channelName': channelName,
//       'requesterName': requesterName,
//       'fallbackToken': fallbackToken,
//     }));
//   } on PlatformException catch (e) {
//     logRed("Failed to show incoming call UI: '${e.message}'.");
//   }
// }
