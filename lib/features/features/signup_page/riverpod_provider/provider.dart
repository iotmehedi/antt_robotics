import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';



final emailControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final passwordControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final isEmailEmpty = StateProvider((ref) => false);
final isPasswordEmpty = StateProvider((ref) => false);
final isConfirmPasswordEmpty = StateProvider((ref) => false);
final isBothPasswordSame = StateProvider((ref) => false);

final bookmarkListListL = StateProvider((ref) => []);
final bookmarkList = StateProvider((ref) => []);

final courseDetailsListL = StateProvider((ref) => []);
final courseLinkList = StateProvider((ref) => []);
final tutorialTitleName = StateProvider((ref) => []);
final nestedId = StateProvider((ref) => []);
final courseDetailsProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('course_details').get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
    in querySnapshot.docs) {
      ref.read(courseDetailsListL.notifier).state.add(doc.data());
    }
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
    in querySnapshot.docs) {
      QuerySnapshot<Map<String, dynamic>> nestedQuerySnapshot =
      await FirebaseFirestore.instance
          .collection('course_details')
          .doc(doc.id)
          .collection('video_url_list')
          .get();

      for (var nestedDoc in nestedQuerySnapshot.docs) {
        ref.read(courseLinkList.notifier).state.add(nestedDoc.data());
        ref.read(nestedId.notifier).state.add(nestedDoc.id);
      }
    }
  } catch (e) {
    // snackbar(message: e.toString(), context: navigatorKey.currentContext!, color: Colors.red);
  }
  return [...ref.read(courseDetailsListL.notifier).state];
});


final email = StateProvider((ref) => "");
final password = StateProvider((ref) => "");
final confirmPassword = StateProvider((ref) => "");
final passwordVisibility = StateProvider((ref) => false);
final confirmPasswordVisibility = StateProvider((ref) => false);