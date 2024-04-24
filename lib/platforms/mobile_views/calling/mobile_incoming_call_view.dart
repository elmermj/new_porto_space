import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/platforms/mobile_views/call/mobile_video_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/accept_call.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/terminate_call.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';

import 'mobile_incoming_call_controller.dart';

class MobileIncomingCallView extends GetView<MobileIncomingCallController> {
  const MobileIncomingCallView({super.key, this.message, this.remoteMessage, required this.isFromTerminated});
  final String? message;
  final RemoteMessage? remoteMessage;
  final bool isFromTerminated;

  @override
  Widget build(BuildContext context) {
    final args = isFromTerminated? remoteMessage:Get.arguments;
    final body = message;
    final channelName = isFromTerminated? remoteMessage!.data['channelName'] : args[0];
    final requesterName = isFromTerminated? remoteMessage!.data['requesterName'] : args[1];
    final fallbackToken = isFromTerminated? remoteMessage!.data['fallbackToken'] : args[2];

    final MobileIncomingCallController controller = isFromTerminated? Get.put(MobileIncomingCallController(
      channelName: channelName,
      fallbackToken: fallbackToken,
      requesterName: requesterName,
      isBackground: isFromTerminated
    )):Get.put(MobileIncomingCallController(isBackground: isFromTerminated));

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.grey[900],
        child: Center(
          child: Text(isFromTerminated? body!:message!),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag:'terminateCall',
            onPressed: () {
              controller.repeatCount.value = 60;
              TerminateCall(
                remoteDeviceToken: controller.fallbackToken!,
                channelName: controller.channelName!,
              );
              isFromTerminated? Get.offAll(()=>MobileHomeView()): Get.back();
            },
            shape: const CircleBorder(),
            child: const Icon(LucideIcons.phoneOff),
          ),
          FloatingActionButton(
            heroTag: 'acceptCall',
            onPressed: () {
              AcceptCall(
                remoteDeviceToken: controller.fallbackToken!,
                channelName: controller.channelName!,
              );
              Get.off(()=>const MobileVideoCallView(), arguments: [
                controller.channelName,
                controller.requesterName,
                controller.fallbackToken
              ]);
            },
            shape: const CircleBorder(),
            child: const Icon(LucideIcons.phoneIncoming),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}