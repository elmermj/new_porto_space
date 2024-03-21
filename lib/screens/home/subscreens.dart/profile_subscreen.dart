import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/screens/home/home_screen_controller.dart';

class ProfileSubscreen extends StatelessWidget {
  const ProfileSubscreen({
    super.key,
    required this.controller,
  });
  
  final HomeScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: controller.margin.value),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black,
            )
          )
        )
      ],
    );
  }
}