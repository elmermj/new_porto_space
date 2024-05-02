import 'package:audioplayers/audioplayers.dart';
import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:new_porto_space/components/notification_snackbar.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/notification/on_message.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/calling/mobile_incoming_call_view.dart';
import 'package:new_porto_space/platforms/mobile_views/chats/mobile_chat_room_controller.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockNotification extends Mock implements RemoteNotification {}

class MockAndroidNotification extends Mock implements AndroidNotification {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockMobileChatRoomController extends Mock implements MobileChatRoomController {}

class MockMobileHomeViewController extends Mock implements MobileHomeViewController {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  group('onMessage', () {
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockRemoteMessage mockRemoteMessage;
    late MockNotification mockNotification;
    late MockAndroidNotification mockAndroidNotification;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockMobileChatRoomController mockMobileChatRoomController;
    late MockMobileHomeViewController mockMobileHomeViewController;
    late MockBox<String> mockUserChatListBox;
    late MockBox<ChatRoomModel> mockChatRoomWithSenderBox;
    late MockBox<Message> mockChatRoomMessagesBox;

    setUp(() {
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockRemoteMessage = MockRemoteMessage();
      mockNotification = MockNotification();
      mockAndroidNotification = MockAndroidNotification();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockMobileChatRoomController = MockMobileChatRoomController();
      mockMobileHomeViewController = MockMobileHomeViewController();
      mockUserChatListBox = MockBox<String>();
      mockChatRoomWithSenderBox = MockBox<ChatRoomModel>();
      mockChatRoomMessagesBox = MockBox<Message>();

      when(mockRemoteMessage.notification).thenReturn(mockNotification);
      when(mockNotification.android).thenReturn(mockAndroidNotification);
      when(mockFirebaseAuth).thenReturn(mockFirebaseAuth);
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('test@example.com');
      when(Get.find<MobileChatRoomController>()).thenReturn(mockMobileChatRoomController);
      when(Get.find<MobileHomeViewController>()).thenReturn(mockMobileHomeViewController);
    });

    test('onMessage with empty title and non-social channel', () async {
      when(mockNotification.title).thenReturn('');
      when(mockAndroidNotification.channelId).thenReturn('non-social');

      await onMessage();

      
      verifyNever(Get.find<MobileIncomingCallController>().onClose());
      verifyNever(Get.to(any, arguments: anyNamed('arguments')));
      verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500)));
    });

    test('onMessage with Logout title', () async {
      when(mockNotification.title).thenReturn('Logout');
      when(mockNotification.body).thenReturn('You have been logged out');

      await onMessage();

      verify(AudioPlayer().play(AssetSource('sounds/negative.wav'))).called(1);
      verify(showSnackBar(title: 'Logout', message: 'You have been logged out', duration: const Duration(milliseconds: 1500))).called(1);
      verifyNever(Get.find<MobileIncomingCallController>().onClose());
      verifyNever(Get.to(any, arguments: anyNamed('arguments')));
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
    });

    test('onMessage with Cancelled Call title', () async {
      when(mockNotification.title).thenReturn('Cancelled Call');

      await onMessage();

      verify(Get.find<MobileIncomingCallController>().onClose()).called(1);
      verify(AudioPlayer().play(AssetSource('sounds/negative.wav'))).called(1);
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
      verifyNever(Get.to(any, arguments: anyNamed('arguments')));
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
    });

    test('onMessage with Call title', () async {
      when(mockNotification.title).thenReturn('Call');
      when(mockNotification.body).thenReturn('Incoming call');
      when(mockRemoteMessage.data).thenReturn({
        'fallbackToken': 'token',
        'channelName': 'channel',
        'requesterName': 'requester'
      });

      await onMessage();

      verify(Get.to(
        () => MobileIncomingCallView(message: 'Incoming call', isFromTerminated: false, remoteMessage: mockRemoteMessage),
        arguments: ['channel', 'requester', 'token', false],
      )).called(1);
      verifyNever(AudioPlayer().play(AssetSource(any.toString())));
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
      verifyNever(Get.find<MobileIncomingCallController>().onClose());
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
    });

    test('onMessage with New Message title', () async {
      when(mockNotification.title).thenReturn('New Message');
      when(mockRemoteMessage.data).thenReturn({
        'msgContent': '{"id":"id","message":"message","createdAt":"2023-05-01T12:00:00.000Z","sendBy":"sender@example.com","status":"delivered"}',
        'senderName': 'Sender',
        'senderEmail': 'sender@example.com',
        'timestamp': '2023-05-01T12:00:00.000Z'
      });
      when(mockUserChatListBox.values).thenReturn(['test@example.com_chat_with_sender@example.com']);
      when(mockChatRoomWithSenderBox.get('test@example.com_chat_with_sender@example.com')).thenReturn(
        ChatRoomModel(
          lastSenderName: 'Sender',
          lastSenderEmail: 'sender@example.com',
          lastSent: DateTime.parse('2023-05-01T12:00:00.000Z'),
          previewMessage: 'message',
          unreadCount: 1,
          roomId: 'test@example.com_chat_with_sender@example.com',
        ),
      );
      when(mockMobileHomeViewController.chatRooms.value).thenReturn([
        ChatRoomModel(
          lastSenderName: 'Sender',
          lastSenderEmail: 'sender@example.com',
          lastSent: DateTime.parse('2023-05-01T12:00:00.000Z'),
          previewMessage: 'message',
          unreadCount: 1,
          roomId: 'test@example.com_chat_with_sender@example.com',
        ),
      ]);

      await onMessage();

      verify(AudioPlayer().play(AssetSource('sounds/magicmarimba.wav'))).called(1);
      verify(mockUserChatListBox.add('test@example.com_chat_with_sender@example.com')).called(1);
      verify(mockChatRoomWithSenderBox.put(
        'test@example.com_chat_with_sender@example.com',
        ChatRoomModel(
          lastSenderName: 'Sender',
          lastSenderEmail: 'sender@example.com',
          lastSent: DateTime.parse('2023-05-01T12:00:00.000Z'),
          previewMessage: 'message',
          unreadCount: 1,
          roomId: 'test@example.com_chat_with_sender@example.com',
        ),
      )).called(1);
      verify(mockMobileHomeViewController.chatRooms.sort((a, b) => b.lastSent!.compareTo(a.lastSent!))).called(1);
      verify(mockChatRoomMessagesBox.put('test@example.com_id', Message(
        id: 'id',
        message: 'message',
        createdAt: DateTime.parse('2023-05-01T12:00:00.000Z'),
        sendBy: 'sender@example.com',
        status: MessageStatus.delivered,
      ))).called(1);
      verify(mockMobileChatRoomController.chatController.addMessage(Message(
        id: 'id',
        message: 'message',
        createdAt: DateTime.parse('2023-05-01T12:00:00.000Z'),
        sendBy: 'sender@example.com',
        status: MessageStatus.delivered,
      ))).called(1);
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
      verifyNever(Get.find<MobileIncomingCallController>().onClose());
      verifyNever(Get.to(any, arguments: anyNamed('arguments')));
      verifyNever(verifyNever(showSnackBar(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500))));
    });

    test('onMessage with default title', () async {
      when(mockNotification.title).thenReturn('Default Title');
      when(mockNotification.body).thenReturn('Default Body');

      await onMessage();

      verify(AudioPlayer().play(AssetSource('sounds/default_notification.wav'))).called(1);
      verify(showSnackBar(title: 'Default Title', message: 'Default Body', duration: const Duration(milliseconds: 1500))).called(1);
      verifyNever(showLogoutWarningDialog(title: anyNamed('title').toString(), message: anyNamed('message').toString(), duration: const Duration(milliseconds: 1500)));
      verifyNever(Get.find<MobileIncomingCallController>().onClose());
      verifyNever(Get.to(any, arguments: anyNamed('arguments')));
    });
  });
}