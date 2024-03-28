import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view_controller.dart';

void main() {
  group('MobileHomeViewController', () {
    late MobileHomeViewController controller;

    setUp(() {
      controller = MobileHomeViewController();
    });

    test('onIdSearch calls Firestore collection with passed id', () async {
      // Arrange
      var mockFirestore = MockFirestore();
      when(mockFirestore.collection('users'))
          .thenReturn(MockCollectionReference() as CollectionReference<Map<String, dynamic>>);
      controller.store = mockFirestore;
      var id = 'testId';

      // Act
      await controller.onIdSearch(id);

      // Assert
      verify(mockFirestore.collection('users').where('id', isEqualTo: id))
          .called(1);
      verifyNoMoreInteractions(mockFirestore);
    });

    test('initializeScrollListener sets margin on scroll', () {
      // Arrange
      controller.margin.value = 0;

      // Act
      controller.initializeScrollListener();
      

      // Assert
      expect(controller.margin.value, 55);
    });
  });
}




class MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: must_be_immutable, subtype_of_sealed_class
class MockCollectionReference extends Mock implements CollectionReference {}

class MockFlutterBluePlus extends Mock implements FlutterBluePlus {} 

