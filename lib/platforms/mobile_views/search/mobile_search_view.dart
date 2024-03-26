import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                margin: const EdgeInsets.only(top: kToolbarHeight),
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
                          onPressed: () {},
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
                        onPressed: () {},
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