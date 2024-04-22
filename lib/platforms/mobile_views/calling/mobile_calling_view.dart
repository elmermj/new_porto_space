import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/terminate_call.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view_controller.dart';

class MobileCallingView extends GetView<MobileCallingViewController> {
  MobileCallingView({super.key});

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
          child: Text('Calling ${controller.receiverName!.split(' ').first}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logYellow("Sending TerminateCall Notif to ${controller.receiverName} with TOKEN ::: ${controller.remoteDeviceToken}");
          TerminateCall(
            remoteDeviceToken: controller.remoteDeviceToken!,
            channelName: controller.channelName!,
          );
          Get.back();
        },
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.phoneOff),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}