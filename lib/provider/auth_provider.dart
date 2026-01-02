import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    // 🔥 WEB FIX (very important)
    _auth.setPersistence(Persistence.LOCAL);
  }

  User? get user => _auth.currentUser;

  // LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on TimeoutException {
      return "Login timeout. Try again.";
    } catch (e) {
      return e.toString();
    }
  }

  // SIGN UP
  Future<String?> signUp(String name, String email, String password) async {
    try {
      final cred = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 10));

      await cred.user?.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on TimeoutException {
      return "Signup timeout. Try again.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
