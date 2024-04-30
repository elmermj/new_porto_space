import 'package:chatview/chatview.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/utils/type_id.dart';

class MessageStatusEnumAdapter extends TypeAdapter<MessageStatus> {
  @override
  final typeId = TypeID.messageStatusEnum; 

  @override
  MessageStatus read(BinaryReader reader) {
    return MessageStatus.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    // Write the index of the enum
    writer.writeInt(obj.index);
  }
}
