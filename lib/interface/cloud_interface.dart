import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudInterface {
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getOngoingChat () async {
    // var chatList = await store.collection('users').doc(auth.currentUser!.uid).collection('ongoing-chats').get();
  }

}