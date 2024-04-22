import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/notification_snackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_logout_and_delete_user_data.dart';

onMessage(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    logYellow('onMessage: $message');
    if (message.notification!.title!.isEmpty && message.notification!.android!.channelId! != 'social') {
      return;
    }
    logYellow("${message.notification!.title!} and ${message.notification!.body!}");
    AudioPlayer audioPlayer = AudioPlayer();
    switch (message.notification!.title!) {

      case 'Logout':
        await audioPlayer.play(AssetSource('sounds/negative.wav'));
        OnLogoutAndDeleteUserData;
        showLogoutWarningDialog(
            title: message.notification!.title!,
            message: message.notification!.body!,
            duration: const Duration(milliseconds: 1500));
        break;

      case "Cancelled Call":
        Get.find<MobileIncomingCallController>().onClose();
        await audioPlayer.play(AssetSource('sounds/negative.wav'));
        logYellow("INITIATED CANCELLED CALL PROCESS");
        logYellow("CURRENT ROUTE == ${Get.currentRoute}");
        return;

      case 'Call':
        final body = message.notification!.body!;
        final fallbackToken = message.data['fallbackToken'];
        final channelName = message.data['channelName'];
        final requesterName = message.data['requesterName'];
        logYellow("$body || $fallbackToken || $channelName");
        logYellow("INITIATED INCOMING CALL PROCESS");
        logYellow("CURRENT ROUTE == ${Get.currentRoute}");
        Get.to(
          () => MobileIncomingCallView(message: body, isFromTerminated: false, remoteMessage: message,),
          arguments: [
            channelName,
            requesterName,
            fallbackToken,
            false
          ]
        );
        break;

      default:
        await audioPlayer.play(AssetSource('sounds/default_notification.wav'));
        break;
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
}