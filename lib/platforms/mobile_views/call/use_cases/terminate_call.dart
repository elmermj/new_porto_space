import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class TerminateCall extends Execute {
  final String remoteDeviceToken;
  final String channelName;

  TerminateCall({
    required this.remoteDeviceToken,
    required this.channelName,
    super.instance = 'TerminateCall'
  });

  @override
  execute() async {
    AudioPlayer().play(AssetSource('sounds/negative.wav'));
    logYellow(instance);
    String url = APIURL.getSendCancelCallNotificationURL();
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
    } else {
      logRed('Failed to send notification. Status code: ${response.statusCode}');
    }
  }
}