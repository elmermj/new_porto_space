import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/utils/execute.dart';

class SaveUserDataToLocal extends Execute{
  final String id;
  final Rx<UserAccountModel> userData;

  SaveUserDataToLocal({required this.id, required this.userData, super.instance = 'SaveUserDataToLocal'});

  @override
  execute() async {
    logYellow('saving to local...');
    final userDataBox = await Hive.openBox<UserAccountModel>('userData');
    await userDataBox.put("${id}_accountData", userData.value);
    await userDataBox.close();
  }
}