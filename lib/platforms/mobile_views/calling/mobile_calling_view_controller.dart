import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';

class MobileCallingViewController extends GetxController {
  String? channelName;
  String? receiverName;
  String? fallbackToken;
  String? remoteDeviceToken;

  MobileCallingViewController({this.channelName, this.receiverName, this.fallbackToken, this.remoteDeviceToken});

  @override
  onInit() {
    super.onInit();
    logYellow("Calling view controller init");
    final arguments = Get.arguments;
    logPink(arguments.toString());
    channelName = arguments[0];
    receiverName = arguments[1];
    fallbackToken = arguments[2];
    remoteDeviceToken = arguments[3];
    logPink(channelName!);
    logPink(receiverName!);
    logPink(fallbackToken!);
  }

}
