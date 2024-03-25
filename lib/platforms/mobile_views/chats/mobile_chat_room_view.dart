import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/constant.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';

class MobileChatRoomView extends GetView<MobileChatRoomController> {
  MobileChatRoomView({super.key});

  @override 
  final MobileChatRoomController controller = Get.put(MobileChatRoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  negativeGrey,
                  positiveColor
                ],
                stops: const [1, 0.63, 0.35]
              )
            )
          ),

        ]
      )
    );
  }
}