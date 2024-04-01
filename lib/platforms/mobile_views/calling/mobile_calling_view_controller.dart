import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';

class MobileCallingViewController extends GetxController {
  String? channelName;
  String? requesterName;
  String? fallbackToken;

  MobileCallingViewController({this.channelName, this.requesterName, this.fallbackToken}){
    onInit();
  }
  @override
    onInit() {
    super.onInit();
    logYellow("Calling view controller init");
    final arguments = Get.arguments;
    channelName = arguments[0];
    requesterName = arguments[1]; 
    fallbackToken = arguments[2];
    logPink(channelName!);
    logPink(requesterName!);
    logPink(fallbackToken!);
  }
}
