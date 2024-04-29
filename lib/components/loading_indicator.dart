import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.title
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LoadingAnimationWidget.flickr(
          leftDotColor: Colors.white, 
          rightDotColor: const Color.fromARGB(255, 58, 58, 58), 
          size: kToolbarHeight
        ),
        Align(
          alignment: AlignmentDirectional(0, (Get.height+(kToolbarHeight))/Get.height  -1),
          child: AutoSizeText(
            title ?? 'Loading',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        )
      ],
    );
  }
}