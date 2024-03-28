import 'package:chatview/chatview.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MobileChatRoomController extends GetxController {

  late ChatController chatController;
  final ScrollController scrollController = ScrollController();

  final List<ChatUser> chatUsers = <ChatUser>[].obs;
  RxList<Message> messages = <Message>[].obs;

  // Future<List<Message>> getLastMessages() async {


  // }

  @override
  void onInit() {
    super.onInit();
    chatController = ChatController(
      initialMessageList: messages, 
      scrollController: scrollController, 
      chatUsers: chatUsers
    );
  }
}