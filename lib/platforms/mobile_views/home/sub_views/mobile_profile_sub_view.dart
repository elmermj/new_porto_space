import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/profile/mobile_verify_profile_view.dart';

class MobileProfileSubView extends StatelessWidget {
  const MobileProfileSubView({
    super.key,
    required this.controller,
  });
  
  final MobileHomeViewController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        margin: EdgeInsets.only(top: controller.marginBodyTop.value),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.black,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Verify Profile'),
                  subtitle: const Text('Verify your profile with your ID and NFC'),
                  onTap: () {
                    Get.to(()=> MobileVerifyProfileView());
                  },
                  trailing: const Icon(LucideIcons.nfc),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}