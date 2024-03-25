import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';

class MobileNearbyViewController extends GetxController {
  
  //dynamic declaration
  RxDouble margin = 0.0.obs;
  RxDouble marginBodyTop = 0.0.obs;
  RxList<BluetoothDevice> nearbyDevices = <BluetoothDevice>[].obs;
  RxString scanningString = "Scanning...".obs;
  
  //static declaration
  FirebaseAuth auth = FirebaseAuth.instance;

  //functionality declaration
  ScrollController scrollController = ScrollController();

  void startScanning() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    scanningString.value = "List of devices";
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        logPink(result.toString());
        if (!nearbyDevices.contains(result.device)) {
          nearbyDevices.add(result.device);
        }
      }
    });
  }

  @override
  void onInit() {
    startScanning();
    initializeScrollListener();
    super.onInit();
  }

  void initializeScrollListener() {
    scrollController.addListener(() {
      final double offset = scrollController.offset;
      final double easedValue = offset / 125;
      final double newMargin = easedValue * 55.0;

      if (newMargin > 55) {
        double additionalMargin = newMargin - 55;
        double fraction = additionalMargin / (158.4 - 55); // Calculate fraction of completion
        marginBodyTop.value = kToolbarHeight * fraction; // Map fraction to range [0, kToolbarHeight]
      } else {
        marginBodyTop.value = 0;
      }
      
      logYellow("MARGIN VALUE ::: $newMargin");
      logYellow("MARGINTOPBODY VALUE ::: ${marginBodyTop.value}");
      logRed('============================================');
    });
  }

  @override
  void onClose() {
    super.onClose();
    FlutterBluePlus.stopScan();
    nearbyDevices.clear();
  }

}