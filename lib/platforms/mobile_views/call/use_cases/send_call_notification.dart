import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class SendCallNotification extends Execute {
  final String localDeviceToken;
  final String remoteDeviceToken;
  final String channelName;
  final String senderName;

  SendCallNotification({
    required this.localDeviceToken,
    required this.remoteDeviceToken, 
    required this.channelName,
    required this.senderName, 
    super.instance = 'SendCallNotification'
  });

  @override
  execute() async {
    logPink("sendCallNotification");
    String url = APIURL.getSendCallNotificationURL();
    Map<String, String> requestBody = {
      'requesterDeviceToken': localDeviceToken,
      'requesterName' : senderName,
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
    ).timeout(
      const Duration(minutes: 1),
      onTimeout: () => showSnackBar(
          title: 'Call Failed', 
          message: 'Time limit reached', 
          duration: const Duration(milliseconds: 1500)
        ),
    );

    if (response.statusCode == 200) {
      logGreen('Notification sent successfully');
    } else {
      logRed('Failed to send notification. Status code: ${response.statusCode}');
    }

    await Future.delayed(
      const Duration(minutes: 1)
    ).whenComplete(
      () {
        if(Get.currentRoute == '/calling'){
          Get.back();
        }
      }
    );
  }
}