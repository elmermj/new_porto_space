import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/mobile_entry_view.dart';
import 'package:new_porto_space/platforms/mobile_views/welcome/mobile_welcome_view_controller.dart';

class MobileWelcomeView extends GetView<WelcomeViewController> {
  MobileWelcomeView({super.key});

  @override
  final WelcomeViewController controller = Get.put(WelcomeViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white,
          ),
          Align(
            alignment: const AlignmentDirectional(
              0,
              0.75
            ),
            child: ElevatedButton(
              onPressed: ()=>Get.to(()=> MobileEntryView()), 
              child: const AutoSizeText('Get Started')
            ),
          )
        ],
      ),
    );
  }
}