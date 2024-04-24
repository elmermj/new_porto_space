import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnSendFriendRequest extends Execute{
  final String remoteDeviceToken;
  final String remoteUserName;
  final String remoteUserUID;

  OnSendFriendRequest({
    required this.remoteDeviceToken,
    required this.remoteUserName,
    required this.remoteUserUID,
    super.instance = 'OnSendFriendRequest'
  });

  @override
  execute() async {
    logYellow(instance);
    String url = APIURL.getSendFriendRequestNotificationURL();
    bool confirmed = false;
    Map<String, String> requestBody = {
      'senderDeviceToken': userData.value.deviceToken!,
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

    batch.set(
      store.collection('users').doc(userUID).collection('friend_requests').doc(remoteUserUID),
      {
        'time': Timestamp.now().toString(),
        'sender': true
      }
    );

    batch.set(
      store.collection('users').doc(remoteUserUID).collection('friend_requests').doc(userUID),
      {
        'time': Timestamp.now().toString(),
        'sender': false
      }
    );

    await batch.commit().then((value) => confirmed=true);

    if(response.statusCode == 200 && confirmed){
      logGreen('Notification sent successfully');
      showSnackBar(
        title: 'Request Sent', 
        message: 'Friend request has been sent to $remoteUserName.', 
        duration: const Duration(milliseconds: 1500)
      );
    }else{
      logRed('Failed to send notification. Status code: ${response.statusCode}');
      showSnackBar(
        title: 'Error Code ${response.statusCode}', 
        message: 'Failed to send request. Network issue.', 
        duration: const Duration(milliseconds: 1500)
      );
    }
  }
}