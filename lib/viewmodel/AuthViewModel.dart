import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw 'Invalid email or password';
      } else {
        throw 'Error signing in: ${e.message}';
      }
    } catch (e) {
      throw 'Error signing in: $e';
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      throw 'The account already exists for that email.';
    } else {
      throw 'Error signing up: ${e.message}';
    }
  } catch (e) {
    throw 'Error signing up: $e';
  }
}

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> checkLoggedIn() async {
     await Future.delayed(const Duration(seconds: 2));
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }
}
