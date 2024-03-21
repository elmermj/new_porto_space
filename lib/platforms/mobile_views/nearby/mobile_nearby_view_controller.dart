import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileNearbyViewController extends GetxController {
  
  //dynamic declaration
  RxDouble margin = 0.0.obs;
  RxList<BluetoothDevice> nearbyDevices = <BluetoothDevice>[].obs;
  RxString scanningString = "Scanning...".obs;
  
  //static declaration
  FirebaseAuth auth = FirebaseAuth.instance;

  //functionality declaration
  ScrollController scrollController = ScrollController();

  void _startScanning() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    scanningString.value = "List of devices";
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!nearbyDevices.contains(result.device)) {
          nearbyDevices.add(result.device);
        }
      }
    });
  }

  @override
  void onInit() {
    _startScanning();
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