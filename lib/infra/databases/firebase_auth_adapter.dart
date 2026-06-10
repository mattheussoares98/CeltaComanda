import 'dart:async';

// [FIREBASE-AUTH-ACTIVE-START]
import 'package:firebase_auth/firebase_auth.dart';
// [FIREBASE-AUTH-ACTIVE-END]

import '../../data/database/database.dart';
// [FIREBASE-AUTH-ACTIVE-START]
import '../../domain/helpers/helpers.dart';
// [FIREBASE-AUTH-ACTIVE-END]

class FirebaseAuthAdapter implements FirebaseAuthStorage {
// [FIREBASE-AUTH-ACTIVE-START]
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});
// [FIREBASE-AUTH-ACTIVE-END]
// [FIREBASE-AUTH-INACTIVE-START]
  // FirebaseAuthAdapter();
// [FIREBASE-AUTH-INACTIVE-END]

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
// [FIREBASE-AUTH-ACTIVE-START]
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception();
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
// [FIREBASE-AUTH-ACTIVE-END]
  }

  @override
  Future<void> logout() async {
// [FIREBASE-AUTH-ACTIVE-START]
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw DomainError.unexpected;
    }
// [FIREBASE-AUTH-ACTIVE-END]
  }

  @override
  Future<bool> isLoggedIn() async {
// [FIREBASE-AUTH-ACTIVE-START]
    bool logged = false;
    final loginSubscription =
        firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        logged = true;
      }
    });
    await Future.delayed(const Duration(seconds: 3));
    loginSubscription.cancel();
    return logged;
// [FIREBASE-AUTH-ACTIVE-END]
// [FIREBASE-AUTH-INACTIVE-START]
    // return false;
// [FIREBASE-AUTH-INACTIVE-END]
  }
}
