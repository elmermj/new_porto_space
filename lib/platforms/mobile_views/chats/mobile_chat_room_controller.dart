import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';

class MobileChatRoomController extends GetxController {

  late ChatController chatController = ChatController(initialMessageList: [], scrollController: scrollController, chatUsers: []);
  final ScrollController scrollController = ScrollController();

  RxList<Message> messages = <Message>[].obs;
  RxBool isBusy = false.obs;
  RxBool isEmpty = false.obs;

  late String? remoteEmail, remoteProfImageUrl, remoteName, localEmail, localProfImageUrl, localName, roomId, remoteDeviceToken;

  @override
  Future<void> onInit() async {
    isBusy.value = true;
    UserAccountModel remoteUserData = Get.arguments;
    localEmail = FirebaseAuth.instance.currentUser!.email!;
    localName = FirebaseAuth.instance.currentUser!.displayName?? FirebaseAuth.instance.currentUser!.email!;
    localProfImageUrl = FirebaseAuth.instance.currentUser!.photoURL?? 'x';
    remoteEmail = remoteUserData.email!;
    remoteName = remoteUserData.name?? remoteUserData.email!;
    remoteProfImageUrl = remoteUserData.photoUrl?? 'x';
    remoteDeviceToken = remoteUserData.deviceToken;

    ChatUser localUser = ChatUser(
      id: localEmail!,
      name: localName!,
      profilePhoto: localProfImageUrl,
    );

    ChatUser remoteUser = ChatUser(
      id: remoteEmail!, 
      name: remoteName!,
      profilePhoto: remoteProfImageUrl,
    );

    roomId = '${FirebaseAuth.instance.currentUser!.email}_chat_with_${remoteUserData.email}';
    logYellow("Remote User Name ::: ${remoteUserData.name}");

    var chatRoomMessagesBox = await Hive.openBox<Message>("${roomId!}_messages");
    var messagesMap = chatRoomMessagesBox.toMap();
    messages.value = messagesMap.values.toList();
    await chatRoomMessagesBox.close();

    chatController = ChatController(
      initialMessageList: messages,
      scrollController: scrollController, 
      chatUsers: [
        localUser,
        remoteUser
      ]
    );

    isBusy.value = false;
    super.onInit();

  }

  @override
  Future<void> onClose() async {
    super.onClose();
    scrollController.dispose();
    if(messages.isNotEmpty){
      var chatRoomDataBox = await Hive.openBox<ChatRoomModel>(
        '${localEmail}_chats',
      );
      chatRoomDataBox.put(
        '${localEmail}_chat_with_$remoteEmail',
        ChatRoomModel(
          profImageUrls: [
            localProfImageUrl!,
            remoteProfImageUrl!
          ],
          lastSenderEmail: chatController.messageStreamController.stream.last.then((value) => value.last.sendBy).toString(),
          lastSenderName: chatController.messageStreamController.stream.last.then((value) => value.last.sendBy).toString(),
          lastSent: DateTime.now(),
          roomId:'${localEmail}_chat_with_$remoteEmail',
          previewMessage: chatController.messageStreamController.stream.last.then((value) => value.last.message).toString(),
        ),
      );
      await chatRoomDataBox.close();
    }
  }
}