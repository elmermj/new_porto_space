import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/loading_indicator.dart';

showNotifcationSnackBar({required String title, required String message, required Duration duration}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    duration: duration,
    borderRadius: 0,
    messageText: SizedBox(
      height: kToolbarHeight/1.8,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AutoSizeText(
              message,
              minFontSize: 8,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.white
              ),
            )
          ), 
          const Expanded(child: LoadingIndicator(title: 'Porto Space',))
        ],
      ),
    ),
    colorText: Colors.white,
    margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
    maxWidth: 480,
    backgroundColor: kDefaultIconDarkColor,
    overlayBlur: 0.5,
    snackStyle: SnackStyle.GROUNDED
  );
}