import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/components/custom_prompt_modal_bottom_sheet.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/send_call_notification.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_view.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_accept_friend_request.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_block_account.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_cancel_friend_request.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_reject_friend_request.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_report_account.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_send_friend_request.dart';
import 'package:new_porto_space/platforms/mobile_views/home/use_cases/on_unblock_account.dart';
import 'package:new_porto_space/platforms/mobile_views/search/mobile_search_view_controller.dart';

class MobileSearchView extends GetView<MobileSearchViewController> {
  MobileSearchView({super.key});

  @override
  final MobileSearchViewController controller = Get.put(MobileSearchViewController());

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: kDefaultIconDarkColor,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Search Result',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () {
            if (controller.initialized && controller.userAccounts.isNotEmpty) {
              return Stack(
                children: [
                  Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.grey[900],
                  ),
                  Container(
                    child: controller.isMoreThan20Results.value?
                      ListView.builder(
                      itemCount: controller.userAccounts.length+1,
                      itemBuilder: (BuildContext context, int index) {
                        if(index == controller.userAccounts.length + 1){
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextButton(
                              child: const Text(
                                'Load More', 
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.lightBlueAccent
                                ),
                              ),
                              onPressed: () => controller.loadMore(),
                            )
                          );
                        }
                        else {
                          return ListTile(
                            title: Text(controller.userAccounts[index].name!),
                            subtitle: Text(controller.userAccounts[index].email!),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {
                                logYellow("pressed");
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (context) {
                                    return Container(
                                      color: kDefaultIconDarkColor,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24)
                                        )
                                      ),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          ListTile(
                                            leading: const Icon(LucideIcons.phone),
                                            title: Text('Call ${controller.userAccounts[index].name}'),
                                          ),
                                          ListTile(
                                            leading: const Icon(LucideIcons.messageCircle),
                                            title: Text('Message ${controller.userAccounts[index].name}'),
                                          ),
                                          ListTile(
                                            leading: const Icon(LucideIcons.video),
                                            title: Text('Video Call ${controller.userAccounts[index].name}'),
                                            onTap: () {
                                              logYellow("channelName ::: ${userData.value.deviceToken!+controller.userAccounts[index].deviceToken!}");
                                              logYellow("remoteUserData (FCM TOKEN) ::: ${controller.userAccounts[index].deviceToken!}");
                                              logYellow("localDeviceToken ::: ${userData.value.deviceToken!}");
                                              SendCallNotification(
                                                channelName: userData.value.deviceToken!+controller.userAccounts[index].deviceToken!,
                                                remoteDeviceToken: controller.userAccounts[index].deviceToken!,
                                                senderName: userData.value.name!,
                                                localDeviceToken: userData.value.deviceToken!
                                              );
                                              Get.to(
                                                () => MobileCallingView(),
                                                arguments: [
                                                  userData.value.deviceToken!+controller.userAccounts[index].deviceToken!,
                                                  controller.userAccounts[index].name,
                                                  userData.value.deviceToken!,
                                                  controller.userAccounts[index].deviceToken
                                                ]
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(LucideIcons.userPlus),
                                            title: Text('Add ${controller.userAccounts[index].name} as a friend'),
                                          ),
                                          ListTile(
                                            leading: const Icon(LucideIcons.mailWarning),
                                            title: Text('Report ${controller.userAccounts[index].name}'),
                                          ),
                                          ListTile(
                                            leading: const Icon(LucideIcons.shieldClose),
                                            title: Text('Block ${controller.userAccounts[index].name}'),
                                          ),
                                        ]
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                            dense: true,
                          );
                        }
                      }
                    )
                    : ListView.builder(
                      itemCount: controller.userAccounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(controller.userAccounts[index].name!),
                          subtitle: Text(controller.userAccounts[index].email!),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              logYellow("pressed");
                              showModalBottomSheet(
                                context: context, 
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: kDefaultIconDarkColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24)
                                      )
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          leading: const Icon(LucideIcons.phone),
                                          title: Text('Call ${controller.userAccounts[index].name}'),
                                        ),
                                        ListTile(
                                          leading: const Icon(LucideIcons.messageCircle),
                                          title: Text('Message ${controller.userAccounts[index].name}'),
                                          onTap: () async {
                                            await Hive.openBox<ChatRoomModel>('${FirebaseAuth.instance.currentUser!.email}_chat_with_${controller.userAccounts[index].email}');
                                            Get.to(
                                              ()=> MobileChatRoomView(),
                                              arguments: controller.userAccounts[index]
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(LucideIcons.video),
                                          title: Text('Video Call ${controller.userAccounts[index].name}'),
                                          onTap: () {
                                            logYellow("channelName ::: ${userData.value.deviceToken!+controller.userAccounts[index].deviceToken!}");
                                            logYellow("remoteUserData (FCM TOKEN) ::: ${controller.userAccounts[index].deviceToken!}");
                                            logYellow("localDeviceToken ::: ${userData.value.deviceToken!}");
                                            SendCallNotification(
                                              channelName: userData.value.deviceToken!+controller.userAccounts[index].deviceToken!,
                                              remoteDeviceToken: controller.userAccounts[index].deviceToken!,
                                              senderName: userData.value.name!,
                                              localDeviceToken: userData.value.deviceToken!
                                            );
                                            Get.to(
                                              () => MobileCallingView(),
                                              arguments: [
                                                userData.value.deviceToken!+controller.userAccounts[index].deviceToken!,
                                                controller.userAccounts[index].name,
                                                userData.value.deviceToken!,
                                                controller.userAccounts[index].deviceToken!
                                              ]
                                            );
                                          },
                                        ),
                                        controller.types[index] == 0? 
                                        ListTile(
                                          leading: const Icon(LucideIcons.userPlus),
                                          title: Text('Add ${controller.userAccounts[index].name} as a friend'),
                                          onTap: () {
                                            logYellow("pressed Add button");
                                            CustomPromptModalBottomSheet(
                                              context: context, 
                                              title: "Add ${controller.userAccounts[index].name} as a friend?", 
                                              leftOption: "Cancel", 
                                              rightOption: "Yes", 
                                              leftOnTap: ()=>Get.back(), 
                                              rightOnTap: (){
                                                OnSendFriendRequest(
                                                  remoteDeviceToken: controller.userAccounts[index].deviceToken ?? 'default',
                                                  remoteUserUID: controller.idResults[index],
                                                  remoteUserName: controller.userAccounts[index].name ?? 'them'
                                                );
                                              },
                                              highlight: true
                                            );
                                          }
                                        ):
                                        (
                                          controller.types[index] == 1?
                                          ListTile(
                                            leading: const Icon(LucideIcons.userPlus),
                                            title: Text('Respond to ${controller.userAccounts[index].name}\'s friend request'),
                                            onTap: () {
                                              logYellow("pressed Respond button");
                                              CustomPromptModalBottomSheet(
                                                context: context, 
                                                title: "${controller.userAccounts[index].name} wants to be your friend", 
                                                leftOption: "Reject", 
                                                rightOption: "Accept", 
                                                leftOnTap: () {
                                                  OnRejectFriendRequest(
                                                    remoteDeviceToken: controller.userAccounts[index].deviceToken ?? 'default',
                                                    remoteUserUID: controller.idResults[index],
                                                  );
                                                  Get.back();
                                                }, 
                                                rightOnTap: (){
                                                  OnAcceptFriendRequest(
                                                    remoteDeviceToken: controller.userAccounts[index].deviceToken ?? 'default',
                                                    remoteUserUID: controller.idResults[index],
                                                  );
                                                  Get.back();
                                                },
                                                highlight: true
                                              );
                                            }
                                          ):
                                          ListTile(
                                            leading: const Icon(LucideIcons.userPlus),
                                            title: Text('Cancel your friend request to ${controller.userAccounts[index].name}'),
                                            onTap: () {
                                              logYellow("pressed Cancel button");
                                              CustomPromptModalBottomSheet(
                                                context: context, 
                                                title: "Cancel your friend request to ${controller.userAccounts[index].name}?", 
                                                leftOption: "Cancel", 
                                                rightOption: "Yes", 
                                                leftOnTap: ()=>Get.back(), 
                                                rightOnTap: (){
                                                  OnCancelFriendRequest(
                                                    remoteDeviceToken: controller.userAccounts[index].deviceToken ?? 'default',
                                                    remoteUserUID: controller.idResults[index],
                                                  );
                                                  Get.back();
                                                },
                                                highlight: true
                                              );
                                            }
                                          )
                                        ),
                                        ListTile(
                                          leading: const Icon(LucideIcons.mailWarning),
                                          title: Text('Report ${controller.userAccounts[index].name}'),
                                          onTap: () {
                                            logYellow("pressed Report button");
                                            CustomPromptModalBottomSheet(
                                              context: context, 
                                              title: "Report ${controller.userAccounts[index].name}?", 
                                              leftOption: "Cancel", 
                                              rightOption: "Yes", 
                                              leftOnTap: ()=>Get.back(), 
                                              rightOnTap: (){
                                                OnReportAccount(
                                                  remoteUserUID: controller.idResults[index],
                                                  remoteUserName: controller.userAccounts[index].name ?? 'default',
                                                  reason: 'Not Defined'
                                                );
                                                Get.back();
                                              },
                                              highlight: true
                                            );
                                          }
                                        ),
                                        controller.types[index] != 3? ListTile(
                                          leading: const Icon(LucideIcons.shieldClose),
                                          title: Text('Block ${controller.userAccounts[index].name}'),
                                          onTap: () {
                                            logYellow("pressed Block button");
                                            CustomPromptModalBottomSheet(
                                              context: context, 
                                              title: "Block ${controller.userAccounts[index].name}?", 
                                              leftOption: "Cancel", 
                                              rightOption: "Yes", 
                                              leftOnTap: ()=>Get.back(), 
                                              rightOnTap: (){
                                                OnBlockAccount(
                                                  remoteUserUID: controller.idResults[index],
                                                  remoteUserName: controller.userAccounts[index].name ?? 'default',
                                                );
                                                Get.back();
                                              },
                                              highlight: true
                                            );
                                          }
                                        ):
                                        ListTile(
                                          leading: const Icon(LucideIcons.shieldClose),
                                          title: Text('Block ${controller.userAccounts[index].name}'),
                                          onTap: () {
                                            logYellow("pressed Unblock button");
                                            CustomPromptModalBottomSheet(
                                              context: context, 
                                              title: "Unlock ${controller.userAccounts[index].name}?", 
                                              leftOption: "Cancel", 
                                              rightOption: "Yes", 
                                              leftOnTap: ()=>Get.back(), 
                                              rightOnTap: (){
                                                OnUnblockAccount(
                                                  remoteUserUID: controller.idResults[index],
                                                  remoteUserName: controller.userAccounts[index].name ?? 'default',
                                                );
                                                Get.back();
                                              },
                                              highlight: true
                                            );
                                          }
                                        ),
                                      ]
                                    ),
                                  );
                                }
                              );
                            },
                          ),
                          dense: true,
                        );
                      }
                    ),
                  )
                ],
              );
            } else if (!controller.initialized && controller.idResults.isEmpty) {
              return Container(
                width: Get.width,
                height: Get.height,
                color: Colors.grey[900],
                child: Center(
                  child: Text("No results found with keyword '${controller.searchTerm.value}'"),
                ),
              );
              
            } else {
              return Container(
                width: Get.width,
                height: Get.height,
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      )
    );
  }
}