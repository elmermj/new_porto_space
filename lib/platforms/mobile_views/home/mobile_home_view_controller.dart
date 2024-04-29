import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';

import '../add_contact/mobile_add_contact_view.dart';

const platform = MethodChannel('networkInfoChannel');

class MobileHomeViewController extends GetxController {

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
    var userChatListBox = await Hive.openBox<List<String>>('${auth.currentUser!.email}_chat_list');
    List<String> userChatList = userChatListBox.get('${auth.currentUser!.email}_chat_list')!;
    for(int i = 0; i<userChatList.length; i++){
      var userChatRoom = await Hive.openBox<ChatRoomModel>(userChatList[i]);
      chatRooms.add(userChatRoom.get(userChatList[i])!);
      await userChatRoom.close();
    }
    await userChatListBox.close();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    logYellow(auth.currentUser!.displayName!);
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


}