import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/screens/home/home_screen_controller.dart';

class TimelineSubscreen extends StatelessWidget {
  const TimelineSubscreen({
    super.key,
    required this.controller,
    required this.userAccountList,
  });

  final HomeScreenController controller;
  final List<UserAccountModel> userAccountList;

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