import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/constant.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/nearby/mobile_nearby_view_controller.dart';
import 'package:new_porto_space/utils/dummydata.dart';
import 'package:rive/rive.dart' as rive;

class MobileNearbyView extends GetView<MobileNearbyViewController> {
  MobileNearbyView({super.key});

  @override
  final MobileNearbyViewController controller = Get.put(MobileNearbyViewController());

  @override
  Widget build(BuildContext context) {
    List<UserAccountModel> userAccountList = [];

    for(int i = 0; i<dummydata.length;i++){
      userAccountList.add(UserAccountModel.fromJson(dummydata[i]));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDefaultIconDarkColor,
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.grey[900],
            ),
            NestedScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller.scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.grey[900],
                  pinned: true,
                  floating: true,
                  centerTitle: true,
                  scrolledUnderElevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSnackBar(
                          title: 'Search',
                          message: 'This feature is not implemented yet',
                          duration: const Duration(seconds: 5),
                        );
                      },
                    )
                  ],
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Get.back(),
                  ),
                  title: const Text(
                    'Search Nearby User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  expandedHeight: 360.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    expandedTitleScale: 1,
                    background: Container(
                      margin: const EdgeInsets.only(top: kToolbarHeight),
                      padding: const EdgeInsets.all(24.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(flex:3, child: rive.RiveAnimation.asset('assets/animation/location_icon.riv', fit: BoxFit.contain, alignment: Alignment.center,)),
                          Expanded(
                            child: AutoSizeText(
                              "Other users will notice your presence once they ping and you're in their search radius.\n They must enable their hotspot in order for your device to detect.",
                              textAlign: TextAlign.center,
                              minFontSize: 8,
                              maxFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      // StretchMode.blurBackground,
                      // StretchMode.fadeTitle,
                    ],
                  ),
                ),
              ],
              body: Obx(
                () => Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: controller.marginBodyTop.value),
                      padding: const EdgeInsets.fromLTRB(12,0,12,12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.black,
                          child: ListView.builder(
                            itemCount: controller.nearbyDevices.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                // leading: CircleAvatar(
                                //   child: Image.network(userAccountList[index].profilePicture!),
                                // ),
                                title: Text(controller.nearbyDevices[index].name),
                                subtitle: Text(controller.nearbyDevices[index].platformName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    showSnackBar(
                                      title: 'Search',
                                      message: 'This feature is not implemented yet',
                                      duration: const Duration(seconds: 5),
                                    );
                                  },
                                ),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                tileColor: Colors.white,
                                selectedTileColor: positiveColor,
                                onLongPress: () {
                                  showSnackBar(
                                    title: 'Search',
                                    message: 'This feature is not implemented yet',
                                    duration: const Duration(seconds: 5),
                                  );
                                },
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.startScanning(),
          backgroundColor: positiveColor,
          child: const Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }
}