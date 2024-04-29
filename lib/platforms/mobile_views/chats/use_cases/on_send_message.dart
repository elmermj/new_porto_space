import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnSendMessage extends Execute {
  final Message message;
  final String remoteUid;
  final String remoteDeviceToken;
  final String senderName;

  OnSendMessage({
    required this.message,
    required this.remoteUid,
    required this.remoteDeviceToken,
    required this.senderName
  }) : super(instance: 'OnSendMessage');
  
  @override
  execute() async {
    String url = APIURL.getSendMessageNotificationURL();
    String msgContent = message.message;
    String senderId = message.sendBy;
    DateTime timestamp = message.createdAt;

    Map<String, dynamic> requestBody = {
      'remoteDeviceToken': remoteDeviceToken,
      'msgContent': msgContent,
      'sender': senderId,
      'remoteUid': remoteUid,
      'timestamp': timestamp.toIso8601String(),
      'channelId': APIURL.getAppChannelID()
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    ).timeout(
      const Duration(minutes: 1),
      onTimeout: () => showSnackBar(
          title: 'Call Failed', 
          message: 'Time limit reached', 
          duration: const Duration(milliseconds: 1500)
        ),
    );

    if (response.statusCode == 200) {
      logGreen('Notification sent successfully');
    } else {
      logRed('Failed to send notification. Status code: ${response.statusCode}');
    }
    
  }

  
}