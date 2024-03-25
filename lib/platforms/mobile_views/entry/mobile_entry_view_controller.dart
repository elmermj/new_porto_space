import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';
import 'package:new_porto_space/platforms/mobile_views/profile/mobile_profile_edit_view.dart';

class MobileEntryViewController extends GetxController{

  //dynamic declaration
  RxBool loginRegister = true.obs; //true = login, false = register

  //static declaration
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //functionality declaration
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  onGoogleLogin() async {
    logYellow("onGoogleLogin");
    showSnackBar(
      title: "Logging In...", 
      message: "You are logging in via Google account. Please wait", 
      duration: const Duration(
        minutes: 1
      )
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn().timeout(
        const Duration(seconds: 55),
        onTimeout: () {
          logRed("onGoogleLogin: Timeout");
          showSnackBar(
            title: "Timeout",
            message: "Something went wrong. Please try again",
            duration: const Duration(
              seconds: 3
            )
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
            duration: const Duration(
              seconds: 3
            )
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
          'deviceToken': deviceToken.value
        });
        update();
        await users.doc(user.uid).get().then((DocumentSnapshot doc) {
          final data = doc.data();

          userData.value = UserAccountModel.fromJson(jsonDecode(data.toString()));
        });
        if(Get.isSnackbarOpen) Get.back();
        
        // Get.off(ProfileEditView(isNew: true,));
        Get.off(MobileProfileEditView(isNew: true,));
    
      }else{
    
        await users.doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
          'deviceToken': deviceToken.value
        });
        update();
        await users.doc(user.uid).get().then((DocumentSnapshot doc) {
          final data = doc.data();

          userData.value = UserAccountModel.fromJson(jsonDecode(data.toString()));

        });
        
        if(Get.isSnackbarOpen) Get.back();
    
        Get.off(MobileHomeView());
    
      }
    } on Exception catch (e) {
      logRed("onGoogleLogin: $e");
      if(Get.isSnackbarOpen) Get.back();
      showSnackBar(
        title: "Error",
        message: "Something went wrong. $e",
        duration: const Duration(
          seconds: 3
        )
      );
    }
  }

  onAppleLogin() async {
    logYellow("onAppleLogin");
    showSnackBar(
      title: "Logging In...",
      message: "You are logging in via Apple account. Please wait",
      duration: const Duration(
        minutes: 1
      )
    );
    try {
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
        Get.off(MobileHomeView());
      });
    } on Exception catch (e) {
      // TODO
      logRed("onAppleLogin: $e");
      if(Get.isSnackbarOpen) Get.back();
      showSnackBar(
        title: "Error",
        message: "Something went wrong. $e",
        duration: const Duration(
          seconds: 3
        )
      );
    }
  }

  onEmailLogin(String email, String password) async{
    logYellow("onEmailLogin");
    showSnackBar(
      title: "Logging In...",
      message: "You are logging in via Email account. Please wait",
      duration: const Duration(
        minutes: 1
      )
    );
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim()
      ).timeout(const Duration(seconds: 55), onTimeout: () {
        logRed("onEmailLogin: Timeout");
        if(Get.isSnackbarOpen) Get.back();
        showSnackBar(
          title: "Timeout",
          message: "Something went wrong. Please try again",
          duration: const Duration(
            seconds: 3
          )
        );
        return auth.getRedirectResult();
      },).onError((error, stackTrace) {
        logRed("onEmailLogin: $error");
        showSnackBar(
          title: "Error",
          message: error.toString(),
          duration: const Duration(
            seconds: 3
          )
        );
        return auth.getRedirectResult();
      }).whenComplete(() {
        logGreen("onEmailLogin: Complete");
        if(Get.isSnackbarOpen) Get.back();
        Get.off(MobileHomeView());
      });
    } on Exception catch (e) {
      logRed("onEmailLogin: $e");
      if(Get.isSnackbarOpen) Get.back();
      showSnackBar(
        title: "Error",
        message: "Something went wrong. $e",
        duration: const Duration(
          seconds: 3
        )
      );
    }
  }

  onEmailSignUp(String email, String password, String confirmPassword) async{
    logYellow("onEmailSignUp");
    if(password.isEmpty || confirmPassword.isEmpty || password!= confirmPassword){
      logRed("onEmailSignUp: Passwords do not match");
      showSnackBar(
        title: "Passwords do not match",
        message: "Please try again",
        duration: const Duration(
          seconds: 3
        )
      );
      return;
    }
    if(email.isEmpty){
      logRed("onEmailSignUp: Email is empty");
      showSnackBar(
        title: "Email is empty",
        message: "Please try again",
        duration: const Duration(
          seconds: 3
        )
      );
      return;
    }
    if(password.isEmpty){
      logRed("onEmailSignUp: Password is empty");
      showSnackBar(
        title: "Password is empty",
        message: "Please try again",
        duration: const Duration(
          seconds: 3
        )
      );
      return;
    }
    showSnackBar(
      title: "Signing Up...",
      message: "You are signing up via Email account. Please wait",
      duration: const Duration(
        minutes: 1
      )
    );
    await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim()
    ).timeout(
      const Duration(seconds: 55),
      onTimeout: () {
        logRed("onEmailSignUp: Timeout");
        showSnackBar(
          title: "Timeout",
          message: "Something went wrong. Please try again",
          duration: const Duration(
            seconds: 3
          )
        );
        return auth.getRedirectResult();
      },
    ).onError(
      (error, stackTrace) {
        logRed("onEmailSignUp: $error");
        showSnackBar(
          title: "Error",
          message: error.toString(),
          duration: const Duration(
            seconds: 3
          )
        );
        return auth.getRedirectResult();
      }
    );
  }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    Hive.box<bool>('isNewApp').put('new', false);
  }
}