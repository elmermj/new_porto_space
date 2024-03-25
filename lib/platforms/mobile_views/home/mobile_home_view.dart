import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/flexible_bar.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/nearby/mobile_nearby_view.dart';
import 'package:new_porto_space/platforms/mobile_views/search/mobile_search_view.dart';
import 'package:new_porto_space/utils/dummydata.dart';

import 'sub_views/mobile_sub_view_index.dart';

class MobileHomeView extends GetView<MobileHomeViewController> {
  MobileHomeView({super.key});

  @override
  final MobileHomeViewController controller = Get.put(MobileHomeViewController());

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
          width: Get.width*0.8,
          backgroundColor: Colors.grey[900],
          child: Container(
            color: Colors.grey[900],
            width: Get.width*0.4,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: ()=>Get.to(()=>MobileNearbyView()), 
                  child: const ListTile(
                    title: Text('Nearby'),
                    subtitle: Text('Allows you to connect to nearby devices'),
                  )
                ),
                TextButton(
                  onPressed: ()=>controller.uploadMyBluetoothInformationToFirestore(), 
                  child: const ListTile(
                    title: Text('Update Bluetooth'),
                    subtitle: Text('Allows you to update your bluetooth information'),
                  )
                ),
              ],
            ),
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
                Obx(
                  ()=> SliverAppBar(
                    backgroundColor: Colors.grey[900],
                    pinned: true,
                    floating: true,
                    centerTitle: true,
                    scrolledUnderElevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          controller.isSearchFieldActive.value =!controller.isSearchFieldActive.value;
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
                        //open the drawer
                        Scaffold.of(context).isDrawerOpen? 
                        Scaffold.of(context).closeDrawer():
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    title: controller.isSearchFieldActive.value?
                    TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search ID',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.searchController.clear();
                            controller.isSearchFieldActive.value = false;
                          }, 
                          icon: const Icon(Icons.cancel)
                        )
                      ),
                      onSubmitted: (value) {
                        controller.userSearch(value);
                        Get.to(()=>MobileSearchView());
                      },
                    ):
                    const Text(
                      'New Porto Space',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    expandedHeight: 180.0,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      expandedTitleScale: 1,
                      background: FlexibleBar(
                        username: controller.username.value,
                        notifCount: 3,
                      ),
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        // StretchMode.blurBackground,
                        // StretchMode.fadeTitle,
                      ],
                    ),
                  ),
                ),
              ],
              body: Obx(() {
                switch(controller.index.value){
                  case 0:
                    return MobileTimelineSubView(controller: controller, userAccountList: userAccountList);
                  case 1:
                    return MobileChatsSubView(controller: controller);
                  case 2:
                    return MobileContactsSubView(controller: controller, userAccountList: userAccountList);
                  default:
                    return MobileProfileSubView(controller: controller,);
                }
              })
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          ()=> Container(
            color: Colors.grey[900],
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: ()=> controller.index.value = 0, 
                  child: Text(
                    "Timeline",
                    style: TextStyle(
                      color: controller.index.value==0? Colors.lightBlueAccent: Colors.white,
                    )
                  )
                ),
                TextButton(
                  onPressed: ()=> controller.index.value = 1, 
                  child: Text(
                    "Chats",
                    style: TextStyle(
                      color: controller.index.value==1? Colors.lightBlueAccent: Colors.white,
                    )
                  )
                ),
                TextButton(
                  onPressed: ()=> controller.index.value = 2, 
                  child: Text(
                    "Contacts",
                    style: TextStyle(
                      color: controller.index.value==2? Colors.lightBlueAccent: Colors.white,
                    )
                  )
                ),
                TextButton(
                  onPressed: ()=> controller.index.value = 3, 
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: controller.index.value==3? Colors.lightBlueAccent: Colors.white,
                    )
                  )
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}