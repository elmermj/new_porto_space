import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';

class MobileChatRoomController extends GetxController {

  late ChatController chatController;
  final ScrollController scrollController = ScrollController();

  RxList<Message> messages = <Message>[].obs;
  RxBool isBusy = false.obs;
  RxBool isEmpty = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isBusy.value = true;
    String? remoteEmail, remoteProfImageUrl, remoteName, localEmail, localProfImageUrl, localName;

    if (Get.arguments.runtimeType == ChatRoomModel) {
      ChatRoomModel chatRoomData = Get.arguments;
      if (chatRoomData.messages != null || chatRoomData.messages!.isNotEmpty) {
        for(int i = 0; i<chatRoomData.messages!.length; i++){
          Message message = chatRoomData.messages![i];
          messages.add(
            Message(
              message: message.message,
              createdAt: message.createdAt,
              sendBy: message.sendBy
            )
          );
        }
      }else {
        isEmpty.value = true;
      }
      
      for(int i = 0; i<chatRoomData.participantsEmails!.length; i++) {
        if(chatRoomData.participantsEmails![i] == FirebaseAuth.instance.currentUser!.email){
          localEmail = chatRoomData.participantsEmails![i];
          localName = "You";
          localProfImageUrl = chatRoomData.profImageUrls![i];
        }else {
          remoteEmail = chatRoomData.participantsEmails![i];
          remoteName = chatRoomData.remoteName;
          remoteProfImageUrl = chatRoomData.profImageUrls![i];
        }
      }

      await Hive.openBox<ChatRoomModel>(
        '${localEmail}_chat_with_$remoteEmail', 
        collection: '${localEmail}_chat_rooms'
      );

      chatController = ChatController(
        initialMessageList: messages, 
        scrollController: scrollController, 
        chatUsers: [
          ChatUser(
            name: localName!,
            id: localEmail!,
          ),
          ChatUser(
            name: remoteName!,
            id: remoteEmail!,
          )
        ]
      );
      isBusy.value = false;
    }
    else {
      // initiate new chat room / get it from local (applicable in search view)
      UserAccountModel remoteUserData = Get.arguments;
      var chatRoomData = await Hive.openBox<ChatRoomModel>(
        '${FirebaseAuth.instance.currentUser!.email}_chat_with_${remoteUserData.email}',
      );
      localEmail = FirebaseAuth.instance.currentUser!.email;
      localName = "You";
      remoteEmail = remoteUserData.email;
      remoteName = remoteUserData.name;
      chatController = ChatController(
        initialMessageList: chatRoomData.get('${FirebaseAuth.instance.currentUser!.email}_chat_with_${remoteUserData.email}')!.messages!, 
        scrollController: scrollController, 
        chatUsers: [
          ChatUser(
            name: localName,
            id: localEmail!,
          ),
          ChatUser(
            name: remoteName!,
            id: remoteEmail!,
          )
        ]
      );
      isBusy.value = false;
    }
  }
}