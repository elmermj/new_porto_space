import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnAcceptFriendRequest extends Execute{
  final String remoteDeviceToken;
  final String remoteUserUID;

  OnAcceptFriendRequest({
    required this.remoteDeviceToken,
    required this.remoteUserUID,
    super.instance = 'OnAcceptFriendRequest'
  });

  @override
  execute() async {
    logYellow(instance);
    bool confirmed = false;
    String url = APIURL.getAcceptFriendRequestNotificationURL();
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

    batch.set(
      store.collection('users').doc(userUID).collection('friends').doc(remoteUserUID),
      {'time': Timestamp.now()}
    );

    batch.set(
      store.collection('users').doc(remoteUserUID).collection('friends').doc(userUID),
      {'time': Timestamp.now()}
    );

    batch.delete(
      store.collection('users').doc(userUID).collection('friend_requests').doc(remoteUserUID)
    );

    batch.delete(
      store.collection('users').doc(remoteUserUID).collection('friend_requests').doc(userUID)
    );

    await batch.commit().then((value) {
      confirmed=true;

    });

    if(response.statusCode == 200 && confirmed){
      logGreen('Notification sent successfully');

      
      showSnackBar(
        title: 'Connected!', 
        message: "You're now befriended with them", 
        duration: const Duration(milliseconds: 800)
      );
    }else{
      logRed('Failed to send notification. Status code: ${response.statusCode}');
      showSnackBar(
        title: 'Error Code ${response.statusCode}', 
        message: 'Failed to accept friend request. Network issue.', 
        duration: const Duration(milliseconds: 800)
      );
    }
  }
}