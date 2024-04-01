import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/platforms/mobile_views/call/mobile_video_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/accept_call.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/cancel_call.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view_controller.dart';

class MobileIncomingCallView extends GetView<MobileCallingViewController> {
  MobileIncomingCallView({super.key, this.message,});
  final String? message;

  @override
  final MobileCallingViewController controller = Get.put(MobileCallingViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.grey[900],
        child: Center(
          child: Text(message!),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              CancelCall(
                remoteDeviceToken: controller.fallbackToken!,
                channelName: controller.channelName!,
              );
              Get.back();
            },
            shape: const CircleBorder(),
            child: const Icon(LucideIcons.phoneOff),
          ),
          FloatingActionButton(
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