import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_view.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileChatsSubView extends StatelessWidget {
  const MobileChatsSubView({
    super.key,
    required this.controller,
  });
  
  final MobileHomeViewController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        margin: EdgeInsets.only(top: controller.marginBodyTop.value),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.black,
            child: Obx(() {
              if(controller.chatRooms.isEmpty) {
                return const Center(
                  child: Text(
                    "No chat rooms found",
                  ),
                );
              }else if (controller.isBusy.value){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.chatRooms.length,
                  itemBuilder: (contextm, index){
                    var chatRoom = controller.chatRooms[index];
                    return ListTile(
                      title: Text(chatRoom.remoteName!),
                      subtitle: AutoSizeText(
                        chatRoom.lastSenderId == FirebaseAuth.instance.currentUser!.uid? 
                        "You : ${chatRoom.previewMessage}" :
                        "${chatRoom.lastSenderName} : ${chatRoom.previewMessage}",
                        maxLines: 2,
                      ),
                      trailing: AutoSizeText(chatRoom.lastSent!.toIso8601String()),
                      onTap: () {
                        Get.to(
                          ()=>MobileChatRoomView(),
                          arguments: chatRoom
                        );
                      },
                    );
                  }
                );
              }
            })
          )
        )
      ),
    );
  }
}