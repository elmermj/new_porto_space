import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MobileSearchViewController extends GetxController{

  int currentIndex = 20;
  int maxIndex = 0;

  RxList<UserAccountModel> userAccounts = <UserAccountModel>[].obs;
  RxBool isMoreThan20Results = false.obs;
  RxList<String> idResults = <String>[].obs;

  MobileHomeViewController homeController = Get.find<MobileHomeViewController>();

  void fetchDataFromHomeController() {
    // Access data from HomeController
    maxIndex = homeController.resultCount.value;
    userAccounts = homeController.userAccountModelsFromSearch;
    isMoreThan20Results.value = homeController.resultCount > 20;
    idResults.value = homeController.userIds;

    logYellow(userAccounts.length.toString());

    // Now you can use userAccounts as needed
    // For example, you can iterate over it:
    for (var user in userAccounts) {
      logGreen(user.name!); // Assuming UserAccountModel has a 'name' property
    }
  }

  void loadMore() async {
    if(maxIndex-20>=currentIndex){
      int tempIndex = currentIndex;
      for(int index = currentIndex; index < tempIndex+20; index++){
        

        currentIndex++;
      }
    }
    if(maxIndex-20<currentIndex){
      for(int index = currentIndex; index < maxIndex; index++){

        currentIndex++;
      }
    }
  }

  @override
  void onInit(){
    super.onInit();
    fetchDataFromHomeController();
  }

}