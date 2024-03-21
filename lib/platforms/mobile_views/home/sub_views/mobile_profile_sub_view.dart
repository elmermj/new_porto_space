import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileProfileSubView extends StatelessWidget {
  const MobileProfileSubView({
    super.key,
    required this.controller,
  });
  
  final MobileHomeViewController controller;

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