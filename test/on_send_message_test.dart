import 'package:chatview/chatview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/use_cases/on_send_message.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';
import 'package:http/http.dart' as http;

class MockMobileChatRoomController extends Mock implements MobileChatRoomController {}

class MockMobileHomeViewController extends Mock implements MobileHomeViewController {}

class MockHttp extends Mock implements http.Client {}

class MockBox extends Mock implements Box<Message> {}

class MockChatRoomModel extends Mock implements ChatRoomModel {}

class MockMessage extends Mock implements Message {}

void main() {
  group('OnSendMessage', () {
    late OnSendMessage onSendMessage;
    late MockMobileChatRoomController mockChatRoomController;
    late MockMobileHomeViewController mockHomeController;
    late MockHttp mockHttp;
    late MockBox mockChatRoomMessagesBox;
    late Uri uri;
    late Message message;
    late ChatRoomModel chatRoomModel;
    late DateTime mockDateTime;
    late String textMessage;
    late String localEmail;
    late String remoteEmail;
    late String roomId;

    setUp(() {
      mockChatRoomController = MockMobileChatRoomController();
      mockHomeController = MockMobileHomeViewController();
      mockHttp = MockHttp();
      mockChatRoomMessagesBox = MockBox();
      uri = Uri.parse('https://example.com');
      mockDateTime = DateTime.now();
      textMessage = 'message';
      localEmail = 'local_email';
      remoteEmail ='remote_email';
      roomId = 'room_id';
      message = Message(
        id: 'id',
        message: textMessage,
        createdAt: mockDateTime,
        sendBy: localEmail,
      );
      chatRoomModel = ChatRoomModel(
        roomId: roomId,
        previewMessage: textMessage,
        lastSent: mockDateTime,
        lastSenderEmail: localEmail,
        remoteEmail: remoteEmail,
        lastSenderName: 'mr. asd',
        unreadCount: 1,
        profImageUrls: ['asd','fgh'],
      );

      onSendMessage = OnSendMessage(
        message: message,
        chatRoomMessagesBox: mockChatRoomMessagesBox,
        receiverDeviceToken: 'receiver_token',
        roomId: 'room_id',
      );
      
      // Mock Get.find calls
      when(Get.put(MobileChatRoomController())).thenReturn(mockChatRoomController);
      when(Get.put(MobileHomeViewController())).thenReturn(mockHomeController);
    });

    test('successful message sending', () async {
      when(mockHttp.post(uri, headers: anyNamed('headers'), body: anyNamed('body')))
      .thenAnswer((_) async => http.Response('{"status": 200}', 200));

      await onSendMessage.execute();

      verify(mockChatRoomController.chatController.addMessage(message)).called(1);
      verify(mockChatRoomMessagesBox.put(any, message..setStatus=MessageStatus.delivered)).called(1);
      verify(mockHomeController.chatRooms.insert(0, chatRoomModel)).called(1);
      verify(mockHomeController.chatRooms.sort(any)).called(1);

      expect(mockHomeController.chatRooms[0], chatRoomModel);
      expect(mockChatRoomMessagesBox.get(any)!.status, message);
    });

    test('failed message sending', () async {
      when(mockHttp.post(uri, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"status": 500}', 500));

      await onSendMessage.execute();

      verify(mockChatRoomController.chatController.addMessage(message)).called(1);
      verify(mockChatRoomMessagesBox.put(any, message..setStatus=MessageStatus.undelivered)).called(1);
      verify(mockHomeController.chatRooms.insert(0, chatRoomModel)).called(1);
      verify(mockHomeController.chatRooms.sort(any)).called(1);

      expect(mockHomeController.chatRooms[0], chatRoomModel);
      expect(mockChatRoomMessagesBox.get(any)!.status, message);
    });

    test('timeout while sending message', () async {
      when(mockHttp.post(uri, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Future.delayed(const Duration(seconds: 5)));

      await onSendMessage.execute();

      verify(mockChatRoomController.chatController.addMessage(message)).called(1);
      verify(mockChatRoomMessagesBox.put(any, message..setStatus=MessageStatus.undelivered)).called(1);
      verify(mockHomeController.chatRooms.insert(0, chatRoomModel)).called(1);
      verify(mockHomeController.chatRooms.sort(any)).called(1);

      expect(mockHomeController.chatRooms[0], chatRoomModel);
      expect(mockChatRoomMessagesBox.get(any)!.status, message);
      verifyShowSnackBarCalled();
    });
  });
}

void verifyShowSnackBarCalled() {
  verify(
    showSnackBar(
      title: 'Send Message Failed',
      message: 'Time limit reached',
      duration: const Duration(milliseconds: 1500),
    ),
  ).called(1);
}
