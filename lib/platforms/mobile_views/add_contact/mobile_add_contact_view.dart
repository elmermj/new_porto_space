import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/add_contact/mobile_add_contact_view_controller.dart';

class MobileAddContactView extends GetView<MobileAddContactViewController> {
  MobileAddContactView({super.key});

  @override
  final MobileAddContactViewController controller = Get.put(MobileAddContactViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: Get.height,
        child: const Center(
          child: Text("Add to list"),
        ),
      ),
    );
  }
}