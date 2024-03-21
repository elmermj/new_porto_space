import 'package:flutter/material.dart';

import '../constant.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key, required this.controller, this.hintText, this.onSubmitted, this.maxLines, this.trailing, this.width,
  });

  final TextEditingController controller;
  final String? hintText;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final Widget? trailing;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: kTextTabBarHeight,
      width: width ?? kTextTabBarHeight*4,
      decoration: defaultGreyBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              maxLines: maxLines ?? 1,
              minLines: maxLines ?? 1,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyleM,
                border: InputBorder.none,
              ),
              onSubmitted: onSubmitted
            ),
          ),
          trailing ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}