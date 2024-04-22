import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';
import 'package:new_porto_space/platforms/mobile_views/welcome/mobile_welcome_view.dart';

import 'mobile_views/entry/mobile_entry_view.dart';

class MobilePortoSpaceApp extends StatelessWidget {
  final bool isNewAppValue;
  final bool isLoggedIn;
  final bool isIncomingCall;
  final RemoteMessage? remoteMessage;

  const MobilePortoSpaceApp({
    Key? key,
    required this.isNewAppValue,
    required this.isLoggedIn, 
    required this.isIncomingCall,
    this.remoteMessage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (isIncomingCall) {
      return GetMaterialApp(
        color: Colors.black,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: MobileIncomingCallView(isFromTerminated: isIncomingCall, remoteMessage: remoteMessage!, message: remoteMessage!.notification!.body,),
        initialRoute: '/',
        routes: {
          '/calling': (context) => MobileCallingView(),
          '/incoming_call': (context) => MobileIncomingCallView(
            isFromTerminated: isIncomingCall,
          ),
        }
      );
    }

    if (isNewAppValue) {
      return GetMaterialApp(
        color: Colors.black,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: MobileWelcomeView(),
        initialRoute: '/',
        routes: {
          '/calling': (context) => MobileCallingView(),
          '/incoming_call': (context) => const MobileIncomingCallView(isFromTerminated: false,),
        }
      );
    } else {
      // Redirect to appropriate View based on login status
      return GetMaterialApp(
        color: Colors.black,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: isLoggedIn
            ? MobileHomeView()
            : MobileEntryView(),
        initialRoute: '/',
        routes: {
          '/calling': (context) => MobileCallingView(),
          '/incoming_call': (context) => const MobileIncomingCallView(isFromTerminated: false,),
        }
      );
    }
  }
}