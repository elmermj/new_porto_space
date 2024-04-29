import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnReceiveMessage extends Execute{
  RemoteMessage remoteMessage;

  OnReceiveMessage({required this.remoteMessage}) : super(instance: 'OnReceiveMessage');

  @override
  execute() async {
    logYellow(instance);
    // Save message to hive database
  }
}