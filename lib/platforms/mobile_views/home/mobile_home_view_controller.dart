import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/mobile_entry_view.dart';

import '../add_contact/mobile_add_contact_view.dart';

const platform = MethodChannel('networkInfoChannel');

class MobileHomeViewController extends GetxController {

  //dynamic declaration
  RxString username = ''.obs;
  RxString userId = ''.obs;

  RxBool isAppBarExpanded = true.obs;
  RxBool isSearchFieldActive = false.obs;

  RxDouble margin = 0.0.obs;  
  RxDouble marginBodyTop = 0.0.obs;

  RxInt index = 0.obs;
  RxInt resultCount = 0.obs;

  RxList<String> userIds = <String>[].obs;

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
      // Invoke platform channel method to get network info
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

  userSearch(String query) async {
    userIds.clear();
    userAccountModelsFromSearch.clear();
    showSnackBar(title: "Search...", message: "Please wait...", duration: const Duration(minutes: 2));
    try {
      // Get a reference to the folder
      final Reference folderRef = storage.ref().child('search_users_index');

      // List files in the folder
      ListResult result = await folderRef.listAll();

      // Filter filenames based on the search query
      List<String> matchingFilenames = result.items
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .map((item) => item.name)
          .toList();
      logGreen("files ::: $matchingFilenames");
      // Download and parse each matching file
      for (String filename in matchingFilenames) {
        Reference fileRef = folderRef.child(filename);
        Uint8List? fileContent = await fileRef.getData(1024 * 1024); // Download file and read its content
        final jsonMap = jsonDecode(utf8.decode(fileContent!));
        String userId = jsonMap['id'];
        userIds.add(userId);
      }

      resultCount.value = userIds.length;
      int count = 0;

      if(Get.isSnackbarOpen) Get.back();

      logGreen(userIds.toString());

      for(String userId in userIds){
        if(count == 20) break;
        await store.collection('users').doc(userId).get().then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>?;
          logPink(data.toString());
          final temp = UserAccountModel(
            name: data?['name'] as String?, // Explicit cast to String or nullable
            email: data?['email'] as String?,
            lastLoginAt: data?['lastLoginAt'] as Timestamp?, // Assuming Timestamp is imported from 'package:cloud_firestore/cloud_firestore.dart'
            dob: data?['dob'] as String?,
            profileDesc: data?['profileDesc'] as String?,
            photoUrl: data?['photoUrl'] as String?,
            interests: data?['interests'] as String?,
            city: data?['city'] as String?,
            currentCompany: data?['currentCompany'] as String?,
            occupation: data?['occupation'] as String?,
            userSettings: data?['userSettings'] as Map<String, dynamic>?,
            followers: data?['followers'] as int?, // Explicit cast to int or nullable
            createdAt: data?['createdAt'] as Timestamp?, // Assuming Timestamp is imported from 'package:cloud_firestore/cloud_firestore.dart'
          );

          userAccountModelsFromSearch.add(temp);
          count++;
        });
      }

      if(userIds.isEmpty){
        showSnackBar(title: "Finished!", message: "No person with that name", duration: const Duration(seconds: 2));
      }else{
        showSnackBar(title: "Finished!", message: "Here's the result", duration: const Duration(seconds: 2));
      }
      

    } on FirebaseException catch (e) {
      if(Get.isSnackbarOpen) Get.back();
      showSnackBar(title: "Error", message: e.toString(), duration: const Duration(minutes: 3));
      logRed(e.toString());
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    logYellow(auth.currentUser!.displayName!);
    initializeScrollListener();
    username.value = auth.currentUser!.displayName!;
    await Hive.openBox<ChatRoomModel>(auth.currentUser!.uid);
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

  Future<void> logoutAndDeleteUserData() async {
    // Step 1: Logout from Firebase
    await FirebaseAuth.instance.signOut();

    // Step 2: Delete user data from Hive
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = "${user.uid}_accountData";
      final userDataBox = await Hive.openBox<UserAccountModel>('userData');
      await userDataBox.delete(userId).catchError(
        (e) => logRed(e.toString()),
      );
      await userDataBox.close();
    }
    Get.offAll(()=>MobileEntryView());
  }

}

class Maths {
  static double exponentialEaseInOut(double t) => t == 0.0 || t == 1.0
      ? t
      : t < 0.5
          ? 0.5 * pow(2, (20 * t) - 10)
          : 1 - 0.5 * pow(2, (-20 * t) + 10);
  static double cubicEaseInOut(double t) =>
      t < 0.5 ? 4 * t * t * t : 0.5 * pow(2 * t - 2, 3) + 1;
}
