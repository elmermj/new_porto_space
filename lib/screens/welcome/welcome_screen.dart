import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/screens/entry/entry_screen.dart';
import 'package:new_porto_space/screens/welcome/welcome_screen_controller.dart';

class WelcomeScreen extends GetView<WelcomeScreenController> {
  WelcomeScreen({super.key});

  @override
  final WelcomeScreenController controller = Get.put(WelcomeScreenController());

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
              onPressed: ()=>Get.to(()=> EntryScreen()), 
              child: const AutoSizeText('Get Started')
            ),
          )
        ],
      ),
    );
  }
}