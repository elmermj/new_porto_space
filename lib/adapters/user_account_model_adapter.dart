import 'package:hive/hive.dart';
import 'package:new_porto_space/models/user_account_model.dart';
import 'package:new_porto_space/utils/type_id.dart';

class UserAccountModelAdapter extends TypeAdapter<UserAccountModel> {

  @override
  final int typeId = TypeID.userAccountModel;

  @override
  UserAccountModel read(BinaryReader reader) {
    return UserAccountModel(
      name: reader.read(),
      dob: reader.read(),
      email: reader.read(),
      city: reader.read(),
      profileDesc: reader.read(),
      followers: reader.read(),
      interests: reader.read(),
      currentCompany: reader.read(),
      occupation: reader.read(),
      photoUrl: reader.read(),
      userSettings: reader.read(),
      lastLoginAt: reader.read(),
      deviceToken: reader.read(),
      createdAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, UserAccountModel obj) {
    writer
      ..write(obj.name)
      ..write(obj.dob)
      ..write(obj.email)
      ..write(obj.city)
      ..write(obj.profileDesc)
      ..write(obj.followers)
      ..write(obj.interests)
      ..write(obj.currentCompany)
      ..write(obj.occupation)
      ..write(obj.photoUrl)
      ..write(obj.userSettings)
      ..write(obj.lastLoginAt)
      ..write(obj.deviceToken)
      ..write(obj.createdAt);
  }
}
