import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileNearbyViewController extends GetxController {
  
  //dynamic declaration
  RxDouble margin = 0.0.obs;
  RxList nearbyDevices = [].obs;
  
  //static declaration
  FirebaseAuth auth = FirebaseAuth.instance;

  //functionality declaration
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(() {
      double offset = scrollController.offset;

      if (offset >= 125) {
        double normalizedOffset = (offset - 125) / 55.0;
        normalizedOffset = normalizedOffset.clamp(0.0, 1.0);

        double easedValue = Maths.cubicEaseInOut(normalizedOffset);
        double newMargin = easedValue * 55.0;

        logYellow("OFFSET VALUE ::: $offset");
        logYellow("newMargin VALUE ::: $newMargin");
        margin.value = newMargin;
        logYellow("MARGIN VALUE ::: ${margin.value}");
      }
    });
    super.onInit();
  }

}