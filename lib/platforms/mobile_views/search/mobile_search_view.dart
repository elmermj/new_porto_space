import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/send_call_notification.dart';
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
          ()=>Stack(
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
                                              userData.value.deviceToken!
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
                                decoration: const BoxDecoration(
                                  color: kDefaultIconDarkColor,
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
                                            userData.value.deviceToken!
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
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}