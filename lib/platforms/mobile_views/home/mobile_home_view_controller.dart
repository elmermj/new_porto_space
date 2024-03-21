import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';

import '../add_contact/mobile_add_contact_view.dart';

class MobileHomeViewController extends GetxController{
  
  //dynamic declaration
  RxString username = ''.obs;
  RxBool isAppBarExpanded = true.obs;
  RxBool isSearchFieldActive = false.obs;
  RxDouble margin = 0.0.obs;
  RxInt index = 0.obs;
  //static declaration
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  //functionality declaration
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  onIdSearch(String id) async {
    var res = await store.collection('users').where('id', isEqualTo: id).get();

    if (res.docs.isNotEmpty) {
      Get.to(()=>MobileAddContactView);
    }
  }

  uploadMyBluetoothInformationToFirestore() async {
    final adapterName = await FlutterBluePlus.adapterName;
    final vara = FlutterBluePlus.adapterStateNow;
    logGreen(adapterName);
    logGreen(vara.name);
  }

  @override
  Future<void> onInit() async {
    logYellow(auth.currentUser!.displayName!);
    username.value = auth.currentUser!.displayName!;
    await Hive.openBox<ChatRoomModel>(auth.currentUser!.uid);

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
        logRed('============================================');
      }
    });

    super.onInit();
  }
}

class Maths {
  static double exponentialEaseInOut(double t) => t == 0.0 || t == 1.0
    ? t
    : t < 0.5
        ? 0.5 * pow(2, (20 * t) - 10)
        : 1 - 0.5 * pow(2, (-20 * t) + 10);
  static double cubicEaseInOut(double t) => t < 0.5
      ? 4 * t * t * t
      : 0.5 * pow(2 * t - 2, 3) + 1;
}