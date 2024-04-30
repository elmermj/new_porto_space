import 'package:chatview/chatview.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/utils/type_id.dart';

class ReplyMessageModelAdapter extends TypeAdapter<ReplyMessage>{

  @override
  final typeId = TypeID.replyMessageModel;

  @override
  ReplyMessage read(BinaryReader reader) {
    return ReplyMessage(
      messageId: reader.read(),
      message: reader.read(),
      replyTo: reader.read(),
      replyBy: reader.read(),
      voiceMessageDuration: reader.read(),
      messageType: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ReplyMessage obj) {
    writer
     ..write(obj.messageId)
     ..write(obj.message)
     ..write(obj.replyTo)
     ..write(obj.replyBy)
     ..write(obj.voiceMessageDuration)
     ..write(obj.messageType);
  }

}