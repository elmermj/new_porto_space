import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/use_cases/save_user_data_to_local.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/use_cases/send_logout_notification_to_old_device.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';
import 'package:new_porto_space/platforms/mobile_views/profile/mobile_profile_edit_view.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnGoogleLogin extends Execute {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;

  OnGoogleLogin({required this.googleSignIn, required this.auth, super.instance = 'OnGoogleLogin'});

  @override
  execute() async {
    logYellow("onGoogleLogin");
    showSnackBar(
      title: "Logging In...", 
      message: "You are logging in via Google account. Please wait", 
      duration: const Duration(minutes: 1)
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn().timeout(
      const Duration(seconds: 55),
      onTimeout: () {
        logRed("onGoogleLogin: Timeout");
        showSnackBar(
          title: "Timeout",
          message: "Something went wrong. Please try again",
          duration: const Duration(seconds: 3)
        );
        return null;
      },
    );
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication.timeout(
      const Duration(seconds: 55),
      onTimeout: () {
        logRed("onGoogleLogin: Timeout");
        showSnackBar(
          title: "Timeout",
          message: "Something went wrong. Please try again",
          duration: const Duration(seconds: 3)
        );
        return googleUser.authentication;
      },
    );
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await auth.signInWithCredential(credential);

    final User user = userCredential.user!;
    final bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (isNewUser) {
      await users.doc(user.uid).set({
        'name': user.displayName!,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'deviceToken': currentFCMToken.value
      });

      await users.doc(user.uid).get().then((DocumentSnapshot doc) async {
        final data = doc.data() as Map<String,dynamic>;
        final temp = UserAccountModel(
          name: data['name'] as String?,
          email: data['email'] as String?,
          lastLoginAt: data['lastLoginAt'] as Timestamp?,
          dob: data['dob'] as String?,
          profileDesc: data['profileDesc'] as String?,
          photoUrl: data['photoUrl'] as String?,
          interests: data['interests'] as String?,
          city: data['city'] as String?,
          currentCompany: data['currentCompany'] as String?,
          occupation: data['occupation'] as String?,
          userSettings: data['userSettings'] as Map<String, dynamic>?,
          followers: data['followers'] as int?,
          deviceToken: data['deviceToken'] as String?,
          createdAt: data['createdAt'] as Timestamp?,
        );

        userData.value = temp;

        SaveUserDataToLocal(id: user.uid, userData: userData);
      });
      if(Get.isSnackbarOpen) Get.back();

      Get.off(MobileProfileEditView(isNew: true,));
    } else {
      await users.doc(user.uid).get().then((DocumentSnapshot doc) async {
        final data = doc.data() as Map<String,dynamic>;

        final temp = UserAccountModel(
          name: data['name'] as String?,
          email: data['email'] as String?,
          lastLoginAt: data['lastLoginAt'] as Timestamp?,
          dob: data['dob'] as String?,
          profileDesc: data['profileDesc'] as String?,
          photoUrl: data['photoUrl'] as String?,
          interests: data['interests'] as String?,
          city: data['city'] as String?,
          currentCompany: data['currentCompany'] as String?,
          occupation: data['occupation'] as String?,
          userSettings: data['userSettings'] as Map<String, dynamic>?,
          followers: data['followers'] as int?,
          deviceToken: data['deviceToken'] as String?,
          createdAt: data['createdAt'] as Timestamp?,
        );
        userData.value = temp;
        if(userData.value.deviceToken != currentFCMToken.value && userData.value.deviceToken!= null) {
          SendLogoutNotificationToOldDevice(newDeviceToken: currentFCMToken.value, oldDeviceToken: userData.value.deviceToken!);
        }
        await users.doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
          'deviceToken': currentFCMToken.value
        });
        userData.value.deviceToken = currentFCMToken.value;
        userData.value.lastLoginAt = Timestamp.now();
        SaveUserDataToLocal(id: user.uid, userData: userData).execute();
      });
      final userDataBox = await Hive.openBox<UserAccountModel>('userData');

      // Retrieve the UserAccountModel object from the box
      final userAccountModel = userDataBox.get("${user.uid}_accountData");
      await userDataBox.close();

      // Extract name and email from the retrieved object
      final name = userAccountModel?.name ?? 'N/A';
      final email = userAccountModel?.email ?? 'N/A';

      // Return name and email as a map
      logGreen( {'name': name, 'email': email}.toString());
      if(Get.isSnackbarOpen) Get.back();

      Get.offAll(()=>MobileHomeView());
    }
  }
}
