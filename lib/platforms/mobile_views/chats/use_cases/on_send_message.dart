import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class OnSendMessage extends Execute {
  final Message message;
  final Box<Message> chatRoomMessagesBox;
  final String receiverDeviceToken;
  final String roomId;
  MessageStatus messageStatus;

  OnSendMessage({
    required this.message,
    required this.chatRoomMessagesBox,
    required this.receiverDeviceToken,
    required this.roomId,
    this.messageStatus = MessageStatus.pending
  }) : super(instance: 'OnSendMessage');
  
  @override
  execute() async {

    var chatController = Get.find<MobileChatRoomController>().chatController;
    String url = APIURL.getSendMessageNotificationURL();
    String senderEmail = FirebaseAuth.instance.currentUser!.email!;
    String senderName = FirebaseAuth.instance.currentUser!.displayName ?? FirebaseAuth.instance.currentUser!.email!;
    DateTime timestamp = DateTime.now();

    logYellow("ISO 8601 ::: ${timestamp.toIso8601String()}");
    logYellow("NORMAL STR ::: $timestamp");

    final messageIndex = updateChatRoomViewPersistence(chatController, senderEmail, timestamp);

    Map<String, dynamic> requestBody = {
      'message': message.message,
      'receiverDeviceToken': receiverDeviceToken,
      'timestamp': message.createdAt.toString(),
      'channelId': APIURL.getAppChannelID(),
      'msgContent': message.toJson().toString(),
      'senderEmail': senderEmail,
      'senderName': senderName,
    };

    logPink("msgContent toJson ::: ${message.toJson()}");

    logPink(jsonEncode(requestBody));

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    logYellow("STATUS CODE ::: ${response.statusCode}");
    logYellow("RESPONSE REASON PHRASE ::: ${response.body}");

    updateMessageStatus(response.statusCode, chatController, messageIndex, senderEmail, timestamp);

    updateHomeChatsViewPersistence(senderEmail, senderName);

  }

  updateChatRoomViewPersistence(
    ChatController chatController,
    String senderEmail,
    DateTime timestamp
  ){
    chatController.addMessage(message);
    final messageIndex = chatController.initialMessageList.isNotEmpty? chatController.initialMessageList.length - 1 : 0;
    chatRoomMessagesBox.put("${senderEmail}_$timestamp", message);
    return messageIndex;
  }

  updateHomeChatsViewPersistence(
    String senderEmail,
    String senderName,
  ){
    logYellow("Updating Home Chat list .... ");
    var controller = Get.find<MobileHomeViewController>();

    int index = 0;
    for(int i = 0; i<controller.chatRooms.length; i++){
      if(controller.chatRooms[i].roomId == roomId){
        index = i;
        break;
      }
    }

    controller.chatRooms.insert(index, ChatRoomModel(
      lastSenderName: senderName,
      lastSenderEmail: senderEmail,
      lastSent: message.createdAt,
      previewMessage: message.message,
      unreadCount: 0,
      roomId: roomId
    ));

    controller.chatRooms.sort((a, b) => b.lastSent!.compareTo(a.lastSent!));
  }

  updateMessageStatus(
    int statusCode, 
    ChatController chatController, 
    int messageIndex,
    String senderEmail,
    DateTime timestamp
  ) {
    logYellow("UPDATING MESSAGE STATUS.... ");
    Message message = chatController.initialMessageList[messageIndex];
    if (statusCode == 200) {
      logGreen('Notification sent successfully');
      message.setStatus = MessageStatus.delivered;

      chatRoomMessagesBox.put("${senderEmail}_$timestamp", message);
    } else {
      logRed('Failed to send notification. Status code: $statusCode');
      message.setStatus = MessageStatus.pending;

      chatRoomMessagesBox.put("${senderEmail}_$timestamp", message);
    }
  }

  Future<int> commitHttpPost(String senderEmail, String senderName, String url) async {
    Map<String, dynamic> requestBody = {
      'message': message.message,
      'receiverDeviceToken': receiverDeviceToken,
      'timestamp': message.createdAt.toString(),
      'channelId': APIURL.getAppChannelID(),
      'msgContent': message.toString(),
      // {
      //   'id': message.id,
      //   'message': message.message,
      //   'createdAt': message.createdAt.toIso8601String(),
      //   'sendBy': message.sendBy,
      //   'replyMessage': message.replyMessage.toJson(),
      //   'reaction': message.reaction.toJson(),
      //   'messageType': message.messageType,
      //   'voiceMessageDuration': message.voiceMessageDuration,
      //   'status': message.status.name
      // },
      'senderEmail': senderEmail,
      'senderName': senderName,
    };

    logPink(jsonEncode(requestBody));

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    ).timeout(
      const Duration(minutes: 1),
      onTimeout: () => showSnackBar(
        title: 'Send Message Failed',
        message: 'Time limit reached', 
        duration: const Duration(milliseconds: 1500)
      ),
    );

    return response.statusCode;
  }

}