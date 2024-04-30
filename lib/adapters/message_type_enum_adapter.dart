import 'package:chatview/chatview.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/utils/type_id.dart';

class MessageTypeEnumAdapter extends TypeAdapter<MessageType> {
  @override
  final typeId = TypeID.messageTypeEnum;

  @override
  MessageType read(BinaryReader reader) {
    return MessageType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    // Write the index of the enum
    writer.writeInt(obj.index);
  }
}