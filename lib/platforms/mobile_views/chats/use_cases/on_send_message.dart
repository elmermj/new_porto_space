import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnSendMessage extends Execute {
  final Message message;
  final ChatController chatController;
  final String receiverDeviceToken;
  final String roomId;
  MessageStatus messageStatus;

  OnSendMessage({
    required this.message,
    required this.chatController,
    required this.receiverDeviceToken,
    required this.roomId,
    this.messageStatus = MessageStatus.pending
  }) : super(instance: 'OnSendMessage');
  
  @override
  execute() async {
    String url = APIURL.getSendMessageNotificationURL();
    String senderEmail = FirebaseAuth.instance.currentUser!.email!;
    String senderName = FirebaseAuth.instance.currentUser!.displayName ?? FirebaseAuth.instance.currentUser!.email!;

    Map<String, dynamic> requestBody = {
      'message': message.message,
      'receiverDeviceToken': receiverDeviceToken,
      'channelId': APIURL.getAppChannelID(),
      'msgContent': message.toJson(),
      'senderEmail': senderEmail,
      'senderName': senderName,
      'timestamp': DateTime.now().toIso8601String()
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
      chatController.initialMessageList.last.setStatus = MessageStatus.delivered;
      message.setStatus = MessageStatus.delivered;
    } else {
      logRed('Failed to send notification. Status code: ${response.statusCode}');
      chatController.initialMessageList.last.setStatus = MessageStatus.undelivered;
      message.setStatus = MessageStatus.undelivered;
    }
    
    chatController.addMessage(message);

    var chatRoomMessagesBox = await Hive.openBox<Message>("${roomId}_messages");
    chatRoomMessagesBox.put("${senderEmail}_${DateTime.now()}", message);
    await chatRoomMessagesBox.close();
    
  }

  statusReturn(){
    return messageStatus;
  }
  
}