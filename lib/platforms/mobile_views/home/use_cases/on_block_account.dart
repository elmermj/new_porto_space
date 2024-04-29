import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnBlockAccount extends Execute {
  final String remoteUserUID;
  final String remoteUserName;

  OnBlockAccount({
    required this.remoteUserUID,
    required this.remoteUserName,
    super.instance = 'OnBlockAccount'
  });

  @override
  execute() async {
    logYellow(instance);
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final userUID = FirebaseAuth.instance.currentUser!.uid;

    var batch = store.batch();

    batch.set(
      store.collection('users').doc(userUID).collection('blocked').doc(remoteUserUID),
      {
        "sender", true
      }
    );

    batch.set(
      store.collection('users').doc(remoteUserUID).collection('blocked').doc(userUID),
      {
        "sender", false
      }
    );

    await batch.commit().then(
      (value) {
        showSnackBar(
          title: 'User Blocked',
          message: "You have blocked $remoteUserName",
          duration: const Duration(milliseconds: 800)
        );
      },
      onError: (error) {
        logRed(error);
        showSnackBar(
          title: 'Error',
          message: error.toString(),
          duration: const Duration(milliseconds: 800)
        );
      }
    );
  }
}