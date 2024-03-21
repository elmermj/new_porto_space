import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/constant.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/utils/dummydata.dart';
import 'package:rive/rive.dart' as rive;

import 'nearby_screen_controller.dart';

class NearbyScreen extends GetView<NearbyScreenController> {
  NearbyScreen({super.key});

  @override
  final NearbyScreenController controller = Get.put(NearbyScreenController());

  @override
  Widget build(BuildContext context) {
    List<UserAccountModel> userAccountList = [];

    for(int i = 0; i<dummydata.length;i++){
      userAccountList.add(UserAccountModel.fromJson(dummydata[i]));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDefaultIconDarkColor,
        drawer: Drawer(
          backgroundColor: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: ()=>Get.to(()=>NearbyScreen()), 
                child: const ListTile(
                  title: Text('Nearby'),
                  subtitle: Text('Allows you to connect to nearby devices'),
                )
              )
            ],
          ),
        ),
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
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showSnackBar(
                        title: 'Menu',
                        message: 'This feature is not implemented yet',
                        duration: const Duration(seconds: 5),
                      );
                    },
                  ),
                  title: const Text(
                    'Search Nearby User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  expandedHeight: 180.0,
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    expandedTitleScale: 1,
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        rive.RiveAnimation.asset('assets/animation/location_icon.riv', fit: BoxFit.fitHeight,),
                        Text(
                          "Other users will notice your presence once they ping and you're in their search radius.\n Other users must enable their hotspot in order for your device to detect.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    stretchModes: [
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
                      margin: EdgeInsets.only(top: controller.margin.value),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.black,
                          child: ListView.builder(
                            itemCount: dummydata.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Image.network(userAccountList[index].profilePicture!),
                                ),
                                title: Text(userAccountList[index].username!),
                                subtitle: Text(userAccountList[index].email!),
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
      )
    );
  }
}