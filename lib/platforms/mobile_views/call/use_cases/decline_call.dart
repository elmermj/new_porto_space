import 'dart:convert';

import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class DeclineCall extends Execute{
  final String remoteDeviceToken;
  final String channelName;

  DeclineCall({
    required this.remoteDeviceToken,
    required this.channelName,
    super.instance = 'DeclineCall'
  }){
    execute();
  }

  @override
  execute() {
    executeWithCatchError(super.instance);
  }

  @override
  executeWithCatchError(String instance) async {
    logYellow("declineCall");
    String url = APIURL.getSendDeclinedCallNotificationURL();
    Map<String, String> requestBody = {
      'receiverDeviceToken': remoteDeviceToken,
      'channelName': channelName,
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