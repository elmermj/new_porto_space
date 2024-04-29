import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Divider kBottomDivider = Divider(
  height: 0,
  color: Colors.white54,
);

const double kExpendedAppBarHeightRatio = 3 / 8;

class OneUiScrollController extends GetxController {
  final RxDouble expandedHeight = 0.0.obs;
  final RxDouble toolbarHeight = kToolbarHeight.obs;
}