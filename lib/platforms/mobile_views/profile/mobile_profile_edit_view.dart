import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/profile/mobile_profile_controller.dart';

class MobileProfileEditView extends GetView<MobileProfileController> {
  MobileProfileEditView({super.key, required this.isNew});
  final bool isNew;
  @override
  final MobileProfileController controller = Get.put(MobileProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}