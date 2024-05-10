import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/features/features/signup_page/riverpod_provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .set({
        'email': email,
        // Add other user data as needed
      });

      return null; // Successful sign-up
    } catch (e) {
      return e.toString(); // Return the error message
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Successful sign-in
    } catch (e) {
      return e.toString(); // Return the error message
    }
  }

  // Sign out
  Future signOut() async {
    await _auth.signOut();
  }

  void clearEmail(StateController<String> emailState) {
    emailState.state = '';
  }
}
