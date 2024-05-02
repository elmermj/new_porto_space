import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';

import '../add_contact/mobile_add_contact_view.dart';

const platform = MethodChannel('networkInfoChannel');

class MobileHomeViewController extends GetxController {

  Rx<DateTime> currentDateTime = DateTime.now().obs;

  //dynamic declaration
  RxString username = ''.obs;
  RxString userId = ''.obs;

  RxBool isAppBarExpanded = true.obs;
  RxBool isSearchFieldActive = false.obs;
  RxBool isBusy = false.obs;

  RxDouble margin = 0.0.obs;  
  RxDouble marginBodyTop = 0.0.obs;

  RxInt index = 0.obs;
  RxInt resultCount = 0.obs;

  RxList<String> userIds = <String>[].obs;
  RxList<int> types = <int>[].obs;
  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;

  RxList<UserAccountModel> userAccountModelsFromSearch = <UserAccountModel>[].obs;


  //static declaration

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;


  //functionality declaration

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? timer;

  onIdSearch(String id) async {
    var res = await store.collection('users').where('id', isEqualTo: id).get();

    if (res.docs.isNotEmpty) {
      Get.to(() => MobileAddContactView);
    }
  }

  uploadMyBluetoothInformationToFirestore() async {
    // final adapterName = await FlutterBluePlus.adapterName;
    // final vara = FlutterBluePlus.adapterStateNow;
    // logGreen(adapterName);
    // logGreen(vara.name);
    try {
      String networkInfo = await platform.invokeMethod('getNetworkInfo');
      logGreen(networkInfo);
    } on PlatformException catch (e) {
      logRed("Failed to get network info: '${e.message}'.");
    }
  }

  getChatListDataFromFirestore() async {
    try {
      // final userDoc = await store.collection('users').doc(auth.currentUser!.uid).collection('ongoing-chats').get();

    } on Exception catch (e) {
      logRed(e.toString());
    }
    
  }

  getUserChatRoomsData() async {
    logYellow("Getting user chat rooms data from local storage (email : ${auth.currentUser!.email})");
    var userChatListBox = await Hive.openBox<ChatRoomModel>('${auth.currentUser!.email}_chats');
    logYellow(userChatListBox.name);
    if(userChatListBox.isNotEmpty){
      chatRooms.value = userChatListBox.values.toList();
      logYellow(chatRooms[0].remoteName!);
    }
  }

  String formatTimeDifference(DateTime lastSent, DateTime currentTime) {
    // Calculate the time difference between currentTime and lastSent
    Duration difference = currentTime.difference(lastSent);

    // Define thresholds for different time units (seconds, minutes, hours, etc.)
    const int second = 1;
    const int minute = 60 * second;
    const int hour = 60 * minute;
    const int day = 24 * hour;
    const int week = 7 * day;

    if (difference.inSeconds < 30) {
      return 'Just now';
    } else if (difference.inSeconds < minute){
      return '${difference.inSeconds}s ago';
    }else if (difference.inSeconds < hour) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inSeconds < day) {
      return '${difference.inHours}h ago';
    } else if (difference.inSeconds < week) {
      return '${difference.inDays}d ago';
    } else {
      // Format the date if it's more than a week ago
      return DateFormat('MMM dd').format(lastSent);
    }
  }

  toChatRoom(String remoteEmail) async {
    //get user data from firebase firestore using email
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserAccountModel remoteUserAccountData = UserAccountModel();
    var docRef = await firestore.collection('users').where('email', isEqualTo: remoteEmail).get();
    if (docRef.docs.isNotEmpty) {
      remoteUserAccountData = UserAccountModel.fromDocumentSnapshot(docRef.docs[0]);
    }
    return remoteUserAccountData;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    logYellow("INIT CURRENT USER ::: ${auth.currentUser!.displayName!}");
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => currentDateTime.value = DateTime.now());
    await getUserChatRoomsData();
    initializeScrollListener();
    username.value = auth.currentUser!.displayName!;
  }

  void initializeScrollListener() {
    scrollController.addListener(() {
      final double offset = scrollController.offset;
      final double easedValue = offset / 125;
      final double newMargin = easedValue * 55.0;

      if (newMargin > 55) {
        double additionalMargin = newMargin - 55;
        double fraction = additionalMargin / (79.2 - 55); // Calculate fraction of completion
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
  Future<void> onClose() async {
    logYellow("MobileHomeViewController close");
    timer!.cancel();
    await Hive.close();
    super.onClose();
  }
}