import 'package:audioplayers/audioplayers.dart';
import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/notification_snackbar.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_logout_and_delete_user_data.dart';

import '../main.dart';

onMessageOpened(){
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    logYellow('onMessageOpenedApp: $message');
    if (message.notification!.title!.isEmpty && message.notification!.android!.channelId! != 'social') {
      return;
    }
    logYellow("${message.notification!.title!} and ${message.notification!.body!}");
    AudioPlayer audioPlayer = AudioPlayer();
    switch (message.notification!.title!) {

      case 'Logout':
        await audioPlayer.play(AssetSource('sounds/negative.wav'));
        OnLogoutAndDeleteUserData;
        showLogoutWarningDialog(
          title: message.notification!.title!,
          message: message.notification!.body!,
          duration: const Duration(milliseconds: 1500)
        );
        break;

      case "Cancelled Call":
        Get.find<MobileIncomingCallController>().onClose();
        await audioPlayer.play(AssetSource('sounds/negative.wav'));
        logYellow("INITIATED CANCELLED CALL PROCESS");
        logYellow("CURRENT ROUTE == ${Get.currentRoute}");
        return;

      case 'Call':
        final body = message.notification!.body!;
        final fallbackToken = message.data['fallbackToken'];
        final channelName = message.data['channelName'];
        final requesterName = message.data['requesterName'];
        logYellow("$body || $fallbackToken || $channelName");
        logYellow("INITIATED INCOMING CALL PROCESS");
        logYellow("CURRENT ROUTE == ${Get.currentRoute}");
        Get.to(
          () => MobileIncomingCallView(message: body, isFromTerminated: false, remoteMessage: message,),
          arguments: [
            channelName,
            requesterName,
            fallbackToken,
            false
          ]
        );
        break;

      case 'New Message':
        await audioPlayer.play(AssetSource('sounds/magicmarimba.wav'));
        //save the new message to local based on respective chat rooms. append the new message to the list of messages in the chatroommodel
        String localEmail = FirebaseAuth.instance.currentUser!.email!;
        Message msgContent = Message.fromJson(message.data['message']);
        String? remoteName = message.data['senderName'];
        String remoteEmail = message.data['senderEmail'];
        //parse date from ison 8601 string
        DateTime timestamp = DateTime.parse(message.data['timestamp']);
        String chatRoomWithSenderKey = "${localEmail}_chat_with_$remoteEmail";

        // IMPORTANT :  
        // This (the ["${localEmail}_chat_list"]) is to get the list of keys for ["${localEmail}_chats" box] of 
        // ongoing chats with other user in order to loop around and display them in the chat list
        var userChatListBox = await Hive.openBox<String>("${localEmail}_chat_list");
        List<String> userChatList = userChatListBox.values.toList();
        
        // IMPORTANT :  
        // This (the ["${localEmail}_chats"]) is to get the list of ongoing chat DATA [ChatRoomModel] objects
        var chatRoomWithSenderBox = await Hive.openBox<ChatRoomModel>("${localEmail}_chats");

        // Add to list if key is not already in the list
        if(!userChatList.contains(chatRoomWithSenderKey)){
          await userChatListBox.add(chatRoomWithSenderKey);
          await userChatListBox.close();
          await chatRoomWithSenderBox.put(chatRoomWithSenderKey, ChatRoomModel(
            lastSenderName: remoteName ?? remoteEmail,
            lastSenderEmail: remoteEmail,
            lastSent: timestamp,
            previewMessage: msgContent.message,
            unreadCount: 1,
            roomId: chatRoomWithSenderKey
          ));
        }else{
          await userChatListBox.close();
          // REMINDER : 
          // This is to get the unread count from chatroom model object from the box 
          // and increment the unread count by 1
          var chatRoomWithSender = chatRoomWithSenderBox.get(chatRoomWithSenderKey);

          await chatRoomWithSenderBox.put(chatRoomWithSenderKey, ChatRoomModel(
            lastSenderName: remoteName ?? remoteEmail,
            lastSenderEmail: remoteEmail,
            lastSent: timestamp,
            previewMessage: msgContent.message,
            unreadCount: chatRoomWithSender!.unreadCount==null? 1 : (chatRoomWithSender.unreadCount as int) + 1,
            roomId: chatRoomWithSenderKey
          ));
        }
        await chatRoomWithSenderBox.close();

        var chatRoomMessagesBox = await Hive.openBox<Message>("${chatRoomWithSenderKey}_messages");
        chatRoomMessagesBox.put("${localEmail}_${msgContent.id}", msgContent);
        await chatRoomMessagesBox.close();
        
        if(Get.currentRoute == '/MobileChatRoomView'){
          var controller = Get.find<MobileChatRoomController>();
          controller.chatController.addMessage(msgContent);
        }

        break;

      default:
        await audioPlayer.play(AssetSource('sounds/default_notification.wav'));
        break;
    }
    
    logYellow("onMessage Data: ${message.notification!.title!}");
    showNotifcationSnackBar(
      title: message.notification!.title!, 
      message: message.notification!.body!, 
      duration: const Duration(milliseconds: 1500)
    );
    messageStreamController.sink.add(message);
    unreadNotificationCount.value++;
  });
}