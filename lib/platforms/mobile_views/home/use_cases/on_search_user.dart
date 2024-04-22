import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnSearchUsers extends Execute {
  final String query;
  final RxList<String> userIds;
  final RxList<UserAccountModel> userAccountModelsFromSearch;
  final RxInt resultCount;
  final FirebaseStorage storage;
  final FirebaseFirestore store;
  bool loading = false;
  
  OnSearchUsers({
    required this.query, 
    required this.userIds, 
    required this.userAccountModelsFromSearch, 
    required this.resultCount, 
    required this.storage,
    required this.store,
    super.instance = 'OnSearchUsers'
  });

  @override
  execute() async {
    logYellow("onSearchUsers");
    userIds.clear();
    userAccountModelsFromSearch.clear();
    showSnackBar(title: "Search...", message: "Please wait...", duration: const Duration(minutes: 2));
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
          name: data?['name'] as String?, 
          email: data?['email'] as String?,
          lastLoginAt: data?['lastLoginAt'] as Timestamp?, 
          dob: data?['dob'] as String?,
          profileDesc: data?['profileDesc'] as String?,
          photoUrl: data?['photoUrl'] as String?,
          interests: data?['interests'] as String?,
          city: data?['city'] as String?,
          currentCompany: data?['currentCompany'] as String?,
          occupation: data?['occupation'] as String?,
          userSettings: data?['userSettings'] as Map<String, dynamic>?,
          followers: data?['followers'] as int?, 
          createdAt: data?['createdAt'] as Timestamp?,
          deviceToken: data?['deviceToken'] as String?,
        );
        logPink("${temp.name}'s deviceToken ::: ${temp.deviceToken}");
        userAccountModelsFromSearch.add(temp);
        count++;
      });
    }

    if(userIds.isEmpty){
      showSnackBar(title: "Finished!", message: "No person with that name", duration: const Duration(seconds: 2));
    }else{
      showSnackBar(title: "Finished!", message: "Here's the result", duration: const Duration(seconds: 1));
    }
    
  }
}