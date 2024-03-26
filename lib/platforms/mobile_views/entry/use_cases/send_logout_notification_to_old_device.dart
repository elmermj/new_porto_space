import 'dart:convert';

import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:http/http.dart' as http;

sendLogoutNotificationToOldDevice(String newDeviceToken, String oldDeviceToken) async {
  String url = APIURL.getSenNotificationURL();
    Map<String, String> requestBody = {
      'oldDeviceToken': userData.value.deviceToken!,
      'newDeviceToken': deviceToken.value,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        logGreen('Notification sent successfully');
      } else {
        logRed('Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (error) {
      logRed('Error: $error');
    }
}