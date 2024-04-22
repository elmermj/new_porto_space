import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnRejectFriendRequest extends Execute{
  final String remoteDeviceToken;
  final String remoteUserUID;

  OnRejectFriendRequest({
    required this.remoteDeviceToken,
    required this.remoteUserUID,
    super.instance = 'OnAcceptFriendRequest'
  });

  @override
  execute() async {
    logYellow(instance);
    String url = APIURL.getRejectFriendRequestNotificationURL();
    Map<String, String> requestBody = {
      'receiverDeviceToken': remoteDeviceToken,
      'senderName': userData.value.name!, 
      'channelId': APIURL.getAppChannelID()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    var batch = store.batch();
    
    batch.delete(
      store.collection('users').doc(userUID).collection('friend_requests').doc(remoteUserUID)
    );

    batch.delete(
      store.collection('users').doc(remoteUserUID).collection('friend_requests').doc(userUID)
    );
    
    await batch.commit();

    if(response.statusCode == 200){
      logGreen('Notification sent successfully');
      showSnackBar(
        title: 'Request Rejected', 
        message: "You've rejected friend request from them.", 
        duration: const Duration(milliseconds: 1500)
      );
    }else{
      logRed('Failed to send notification. Status code: ${response.statusCode}');
      showSnackBar(
        title: 'Error Code ${response.statusCode}', 
        message: 'Failed to reject friend request. Network issue.', 
        duration: const Duration(milliseconds: 1500)
      );
    }
  }
}