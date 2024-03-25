import 'package:chatview/chatview.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/models/message_model.dart';
import 'package:new_porto_space/models/user_model.dart';

class MobileChatRoomController extends GetxController {

  late final chatController;
  final ScrollController scrollController = ScrollController();

  final List<ChatUser> chatUsers = <ChatUser>[].obs;
  RxList<Message> messages = <Message>[].obs;

  // Future<List<Message>> getLastMessages() async {


  // }

  @override
  void onInit() {
    chatController = ChatController(
      initialMessageList: messages, 
      scrollController: scrollController, 
      chatUsers: chatUsers
    );
  }
}