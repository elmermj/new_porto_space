import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPromptModalBottomSheet {
  final BuildContext context;
  final String title;
  final String leftOption;
  final String rightOption;
  final Function()? leftOnTap;
  final Function()? rightOnTap;
  final bool highlight;

  CustomPromptModalBottomSheet({
    required this.context,
    required this.title,
    required this.leftOption,
    required this.rightOption,
    required this.leftOnTap,
    required this.rightOnTap,
    required this.highlight,
  }){
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        minHeight: 5,
        maxHeight: Get.height * 0.25
      ),
      builder: (context){
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: leftOnTap,
                      child: Center(
                        child: Text(
                          leftOption,
                          style: TextStyle(
                            fontSize: 16,
                            color: highlight? Get.theme.colorScheme.error : Get.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: rightOnTap,
                      child: Center(
                        child: Text(
                          rightOption,
                          style: TextStyle(
                            fontSize: 16,
                            color: highlight? Get.theme.colorScheme.error : Get.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}