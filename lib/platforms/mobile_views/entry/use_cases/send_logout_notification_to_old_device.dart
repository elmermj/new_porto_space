import 'dart:convert';

import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:http/http.dart' as http;
import 'package:new_porto_space/utils/execute.dart';

class SendLogoutNotificationToOldDevice extends Execute{

  final String newDeviceToken;
  final String oldDeviceToken;

  SendLogoutNotificationToOldDevice({
    required this.newDeviceToken, 
    required this.oldDeviceToken, 
    super.instance = 'SendLogoutNotificationToOldDevice'
  });

  @override
  execute() async {
    String url = APIURL.getSendNotificationURL();
    Map<String, String> requestBody = {
      'oldDeviceToken': userData.value.deviceToken!,
      'newDeviceToken': currentFCMToken.value,
      'channelId': APIURL.getAppChannelID()
    };

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
  }
}