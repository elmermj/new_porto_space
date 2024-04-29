import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/use_cases/on_send_message.dart';

class MobileChatRoomView extends GetView<MobileChatRoomController> {
  MobileChatRoomView({super.key});

  @override 
  final MobileChatRoomController controller = Get.put(MobileChatRoomController());

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      body: Obx(
        () {
          if (!controller.isBusy.value) {
            return ChatView(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: controller.chatController.chatUsers[1].profilePhoto == 'x' ||  controller.chatController.chatUsers[1].profilePhoto == null? 
                      const AssetImage('assets/pics/profile.png') as ImageProvider :
                      NetworkImage(controller.chatController.chatUsers[1].profilePhoto!),
                    ),
                    const SizedBox(width: 16,),
                    Text(controller.chatController.chatUsers[1].name),
                  ],
                ),
                backgroundColor: Colors.grey[900],
              ),
              onSendTap: (message, replyMessage, messageType) async {
                OnSendMessage(
                  message: Message(
                    id: "${DateTime.now().microsecondsSinceEpoch}",
                    createdAt: DateTime.now(),
                    message: message,
                    sendBy: userEmail,
                    replyMessage: replyMessage,
                    messageType: messageType,
                  ),
                  chatController: controller.chatController, 
                  receiverDeviceToken: controller.remoteDeviceToken!, 
                  roomId: controller.roomId!
                );
                // Message messageContent = Message(
                //   id: "${userEmail}_${DateTime.now()}",
                //   createdAt: DateTime.now(),
                //   message: message,
                //   sendBy: userEmail,
                //   replyMessage: replyMessage,
                //   messageType: messageType,
                // );
                // controller.chatController.addMessage(messageContent);

                // var chatRoomMessagesBox = await Hive.openBox<Message>("${controller.roomId!}_messages");
                // chatRoomMessagesBox.put("${userEmail}_${DateTime.now()}", messageContent);
                // await chatRoomMessagesBox.close();

                // Future.delayed(const Duration(milliseconds: 1500), () {
                //   controller.chatController.initialMessageList.last.setStatus =
                //       MessageStatus.pending;
                // });
                // Future.delayed(const Duration(seconds: 1), () {
                //   controller.chatController.initialMessageList.last.setStatus = MessageStatus.delivered;
                // });
              },
              loadingWidget: const CircularProgressIndicator(),
              chatController: controller.chatController, 
              currentUser: controller.chatController.chatUsers[0], 
              chatViewState: controller.isBusy.value? 
                ChatViewState.loading : 
                controller.isEmpty.value? ChatViewState.noData : ChatViewState.hasMessages,
              chatViewStateConfig: ChatViewStateConfiguration(
              loadingWidgetConfig: ChatViewStateWidgetConfiguration(
                  loadingIndicatorColor: Get.iconColor,
                ),
                onReloadButtonTap: () {},
              ),
              chatBackgroundConfig: ChatBackgroundConfiguration(
                backgroundColor: Colors.grey[900]
              ),
            );
          }else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}