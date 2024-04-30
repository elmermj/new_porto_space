import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileChatRoomController extends GetxController {

  late ChatController chatController = ChatController(initialMessageList: [], scrollController: scrollController, chatUsers: []);
  final ScrollController scrollController = ScrollController();
  late String? 
              remoteEmail,
              remoteProfImageUrl,
              remoteName,
              localEmail,
              localProfImageUrl,
              localName,
              roomId,
              remoteDeviceToken;

  late Box<Message> chatRoomMessagesBox;

  RxList<Message> messages = <Message>[].obs;
  RxBool isBusy = false.obs;
  RxBool isEmpty = false.obs;

  @override
  Future<void> onInit() async {
    isBusy.value = true;
    if (Get.arguments.runtimeType == UserAccountModel) {
      UserAccountModel remoteUserData = Get.arguments;
      localEmail = FirebaseAuth.instance.currentUser!.email!;
      localName = FirebaseAuth.instance.currentUser!.displayName?? FirebaseAuth.instance.currentUser!.email!;
      localProfImageUrl = FirebaseAuth.instance.currentUser!.photoURL?? 'x';
      remoteEmail = remoteUserData.email!;
      remoteName = remoteUserData.name?? remoteUserData.email!;
      remoteProfImageUrl = remoteUserData.photoUrl?? 'x';
      remoteDeviceToken = remoteUserData.deviceToken;
    }else {
      ChatRoomModel chatRoomData = Get.arguments;
      localEmail = FirebaseAuth.instance.currentUser!.email!;
      localName = FirebaseAuth.instance.currentUser!.displayName?? FirebaseAuth.instance.currentUser!.email!;
      localProfImageUrl = FirebaseAuth.instance.currentUser!.photoURL?? 'x';
      remoteEmail = chatRoomData.remoteEmail!;
      remoteName = chatRoomData.remoteName?? chatRoomData.remoteEmail!;
      remoteProfImageUrl = chatRoomData.profImageUrls!.isEmpty? 'x' : chatRoomData.profImageUrls![1];
      remoteDeviceToken = chatRoomData.remoteDeviceToken!;
    }

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

    roomId = '${FirebaseAuth.instance.currentUser!.email}_chat_with_$remoteEmail';
    logYellow("Remote User Name ::: $remoteName");

    chatRoomMessagesBox = await Hive.openBox<Message>("${roomId!}_messages");
    var messagesMap = chatRoomMessagesBox.toMap();
    messages.value = messagesMap.values.toList();

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
    isBusy.value = false;
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await chatRoomMessagesBox.close();
    if(messages.isNotEmpty){
      var chatRoomDataBox = Hive.box<ChatRoomModel>(
        '${localEmail}_chats',
      );
      chatRoomDataBox.put(
        '${localEmail}_chat_with_$remoteEmail',
        ChatRoomModel(
          profImageUrls: [
            localProfImageUrl ?? 'x',
            remoteProfImageUrl ?? 'x'
          ],
          lastSenderEmail: chatController.initialMessageList.last.sendBy,
          lastSenderName: chatController.initialMessageList.last.sendBy,
          lastSent: chatController.initialMessageList.last.createdAt,
          remoteName: remoteName!,
          roomId:'${localEmail}_chat_with_$remoteEmail',
          previewMessage: chatController.initialMessageList.last.message,
          remoteEmail: remoteEmail!,
          remoteDeviceToken: remoteDeviceToken!,
        ),
      );
      await Get.find<MobileHomeViewController>().getUserChatRoomsData();
    }
  }
}