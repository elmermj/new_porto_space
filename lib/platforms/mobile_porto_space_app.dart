import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/entry/entry_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/welcome/welcome_screen.dart';

class MobilePortoSpaceApp extends StatelessWidget {
  final bool isNewAppValue;
  final bool isLoggedIn;

  const MobilePortoSpaceApp({
    Key? key,
    required this.isNewAppValue,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Perform app validation based on the isNewApp flag
    if (isNewAppValue) {
      // Redirect to WelcomeScreen for new users
      return GetMaterialApp(
        color: Colors.black,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      );
    } else {
      // Redirect to appropriate screen based on login status
      return GetMaterialApp(
        color: Colors.black,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: isLoggedIn
            ? HomeScreen()
            : EntryScreen(),
      );
    }
  }
}