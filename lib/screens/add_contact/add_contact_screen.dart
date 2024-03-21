import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/screens/add_contact/add_contact_screen_controller.dart';

class AddContactScreen extends GetView<AddContactScreenController> {
  AddContactScreen({super.key});

  @override
  final AddContactScreenController controller = Get.put(AddContactScreenController());

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