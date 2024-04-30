import 'package:chatview/chatview.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/utils/type_id.dart';

class MessageModelAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = TypeID.messageModel;

  @override
  Message read(BinaryReader reader) {
    return Message(
      id: reader.read(),
      message: reader.read(),
      createdAt: reader.read(),
      sendBy: reader.read(),
      status: reader.read(),
      replyMessage: reader.read(),
      reaction: reader.read(),
      voiceMessageDuration: reader.read(),
      messageType: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..write(obj.id)
      ..write(obj.message)
      ..write(obj.createdAt)
      ..write(obj.sendBy)
      ..write(obj.status)
      ..write(obj.replyMessage)
      ..write(obj.reaction)
      ..write(obj.voiceMessageDuration)
      ..write(obj.messageType);
  }
}