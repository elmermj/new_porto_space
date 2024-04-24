import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/call/mobile_call_controller.dart';

class MobileVideoCallView extends GetView<MobileCallController> {
  const MobileVideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ()=> Stack(
          //agora video call UI
          children: [
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: controller.engine,
                canvas: const VideoCanvas(uid: 0),
                useFlutterTexture: controller.isUseFlutterTexture,
                useAndroidSurfaceView: controller.isUseAndroidSurfaceView,
              ),
              onAgoraVideoViewCreated: (viewId) {
                controller.engine.startPreview();
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.of(controller.remoteUid.map(
                    (e) => SizedBox(
                      width: 120,
                      height: 120,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: controller.engine,
                          canvas: VideoCanvas(uid: e),
                          connection:
                              RtcConnection(channelId: controller.controller.text),
                          useFlutterTexture: controller.isUseFlutterTexture,
                          useAndroidSurfaceView: controller.isUseAndroidSurfaceView,
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}