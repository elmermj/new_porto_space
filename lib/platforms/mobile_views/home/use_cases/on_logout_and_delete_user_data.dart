import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/mobile_entry_view.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnLogoutAndDeleteUserData extends Execute {

  OnLogoutAndDeleteUserData({super.instance = 'OnLogoutAndDeleteUserData'});

  @override
  execute() async {
    // Step 1: Logout from Firebase
    await FirebaseAuth.instance.signOut();

    // Step 2: Delete user data from Hive
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = "${user.uid}_accountData";
      final userDataBox = await Hive.openBox<UserAccountModel>('userData');
      await userDataBox.delete(userId).catchError(
        (e) => logRed(e.toString()),
      );
      await userDataBox.close();
      await userDataBox.clear();
    }
    Get.off(()=>MobileEntryView());
  }
}