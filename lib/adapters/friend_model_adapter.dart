import 'package:hive/hive.dart';
import 'package:new_porto_space/models/friend_model.dart';

class FriendModelAdapter extends TypeAdapter<FriendModel> {
  @override
  final int typeId = 201;

  @override
  FriendModel read(BinaryReader reader) {
    return FriendModel(
      friendUID: reader.read(),
      friendName: reader.read(),
      friendEmail: reader.read(),
      dateBefriended: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, FriendModel obj) {
    writer.write(obj.friendUID);
    writer.write(obj.friendName);
    writer.write(obj.friendEmail);
    writer.write(obj.dateBefriended);
  }
}