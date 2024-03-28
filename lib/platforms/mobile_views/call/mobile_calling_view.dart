import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/call/mobile_call_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/cancel_call.dart';

class MobileCallingView extends GetView<MobileCallController> {
  MobileCallingView({super.key});

  @override
  final MobileCallController controller = Get.put(MobileCallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.grey[900],
        child: Center(
          child: Text('Calling ${controller.remoteUserData!.name!.split(' ').first}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CancelCall(
            remoteDeviceToken: controller.remoteUserData!.deviceToken!,
            channelName: controller.channelName!,
            engine: controller.engine,
            rtcEngineEventHandler: controller.rtcEngineEventHandler
          );
          Get.back();
        },
        child: const Icon(Icons.call),
      )
    );
  }
}