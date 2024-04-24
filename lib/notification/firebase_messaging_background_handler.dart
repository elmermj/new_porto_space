import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/initialization.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_porto_space_app.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_logout_and_delete_user_data.dart';
import 'package:new_porto_space/secret_url.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logYellow("THIS IS BACKGROUND!!!!!!");
  String? soundFilePath;
  String? title = message.notification!.title;
  AudioPlayer audioPlayer = AudioPlayer();
  logCyan("NOTIF TITLE ::: $title ||| PAYLOAD ::: ${message.notification!.android!.channelId}");
  if (message.notification!.android!.channelId! == APIURL.getAppChannelID()) {
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
        await backgroundNotificationInitialization();

        unreadNotificationCount.value++;
        logCyan('Handling a background message ${message.notification!.body}');
        if(kIsWeb){
          logRed('Web is not supported yet');
          exit(1);
        } else {
          if(Platform.isAndroid || Platform.isIOS){     
            // await requestPermissions();
            runApp(
              MobilePortoSpaceApp(
                isNewAppValue: false,
                isLoggedIn: isLogin.value,
                isIncomingCall: true,
                remoteMessage: message,
              )
            );
          }
        } 
        break;

      case 'Cancelled Call':
        Get.find<MobileIncomingCallController>().onClose();
        await audioPlayer.stop();
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

    unreadNotificationCount.value++;
    logCyan('Handling a background message ${message.notification!.body}');
  }
}