import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';
import 'package:new_porto_space/utils/execute.dart';
import 'package:http/http.dart' as http;

class CancelCall extends Execute {
  final String remoteDeviceToken;
  final String channelName;
  final RtcEngine engine;
  final RtcEngineEventHandler rtcEngineEventHandler;

  CancelCall({
    required this.remoteDeviceToken,
    required this.channelName,
    required this.engine,
    required this.rtcEngineEventHandler,
    super.instance = 'CancelCall'
  }){
    execute();
  }

  @override
  execute() {
    executeWithCatchError(super.instance);
  }

  @override
  executeWithCatchError(String instance) async {
    logYellow(instance);
    engine.unregisterEventHandler(rtcEngineEventHandler);
    await engine.leaveChannel().then((value) => logGreen("Left Agora RTC channel"), onError: (error) => logRed("Failed to leave Agora RTC channel: $error"));
    await engine.release().then((value) => logGreen("Agora RTC engine released"), onError: (error) => logRed("Failed to release Agora RTC engine: $error"));
    
    String url = APIURL.getSendCancelCallNotificationURL();
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