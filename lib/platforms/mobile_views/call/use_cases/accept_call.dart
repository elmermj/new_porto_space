import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_calling_view.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class AcceptCall extends Execute {
  final String remoteDeviceToken;
  final String channelName;

  AcceptCall({
    required this.remoteDeviceToken,
    required this.channelName,
    super.instance = 'AcceptCall'
  });

  @override
  execute() async {
    logYellow("acceptCall");
    String url = APIURL.getSendAcceptCallNotificationURL();
    Map<String, String> requestBody = {
      'receiverDeviceToken': remoteDeviceToken,
      'channelName': channelName,
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
      Get.off(
        ()=> MobileCallingView(),
        arguments: [
          channelName,
          remoteDeviceToken,
        ]
      );
    } else {
      logRed('Failed to send notification. Status code: ${response.statusCode}');
    }
  }
}