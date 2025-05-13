import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {

    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );


    final uid = credentials.user!.uid;
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });


    _user = credentials.user;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  void _onAuthChanged(User? u) {
    _user = u;
    notifyListeners();
  }
}
