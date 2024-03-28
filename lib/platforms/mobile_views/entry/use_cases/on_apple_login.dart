import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnAppleLogin extends Execute{
  final FirebaseAuth auth;

  OnAppleLogin({required this.auth, super.instance = 'OnAppleLogin'});

  @override
  execute() async {
    await executeWithCatchError(super.instance);
  }

  @override
  executeWithCatchError(String instance) async {
    logYellow("onAppleLogin");
    showSnackBar(
      title: "Logging In...",
      message: "You are logging in via Apple account. Please wait",
      duration: const Duration(
        minutes: 1
      )
    );
    await auth.signInWithProvider(
      AppleAuthProvider()
    ).timeout(
      const Duration(seconds: 55),
      onTimeout: () {
        logRed("onAppleLogin: Timeout");
        if(Get.isSnackbarOpen) Get.back();
        showSnackBar(
          title: "Timeout",
          message: "Something went wrong. Please try again",
          duration: const Duration(
            seconds: 3
          )
        );
        return auth.getRedirectResult();
      },
    ).onError((error, stackTrace) {
      logRed("onAppleLogin: $error");
      if(Get.isSnackbarOpen) Get.back();
      showSnackBar(
        title: "Error",
        message: error.toString(),
        duration: const Duration(
          seconds: 3
        )
      );
      return auth.getRedirectResult();
    }).whenComplete(() {
      logGreen("onAppleLogin: Complete");
      if(Get.isSnackbarOpen) Get.back();
      Get.off(()=>MobileHomeView());
    });
  }
}