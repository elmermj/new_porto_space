import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/constant.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/screens/home/home_screen_controller.dart';
import 'package:new_porto_space/utils/dummydata.dart';

class ContactsSubscreen extends StatelessWidget {
  const ContactsSubscreen({
    super.key,
    required this.controller,
    required this.userAccountList,
  });

  final HomeScreenController controller;
  final List<UserAccountModel> userAccountList;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}