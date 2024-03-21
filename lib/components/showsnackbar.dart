import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar({required String title, required String message, required Duration duration}) {
  Get.isSnackbarOpen?Get.back():null;
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: duration,
    borderRadius: 0,
    messageText: SizedBox(
      height: kToolbarHeight/1.8,
      child: AutoSizeText(
        message,
        minFontSize: 8,
        maxLines: 3,
        style: const TextStyle(
          color: Colors.white
        ),
      ),
    ),
    colorText: Colors.white,
    margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
    maxWidth: 480,
    backgroundColor: Colors.lightBlueAccent,
    overlayBlur: 0.5,
  );
}