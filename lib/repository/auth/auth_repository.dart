import 'dart:async';


import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User?> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      return user;
    } catch (_) {}
    return null;
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {}
  }

  @override
  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception(e.code);
      }
    }
    return null;
  }

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<bool> changePassword({required String newPassword, required String oldPassword}) async {
    try {
      bool success = false;
      AuthCredential credential = EmailAuthProvider.credential(
        email: _firebaseAuth.currentUser!.email!,
        password: oldPassword,
      );
      UserCredential? authResult = await _firebaseAuth.currentUser
          ?.reauthenticateWithCredential(credential);
      // Thực hiện xác thực lại người dùng
      await _firebaseAuth.currentUser
          ?.updatePassword(newPassword)
          .then((_) => {success = true});
      return success;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User?> logInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User?> logInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login( permissions: (["public_profile", "email"]));

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      final credential =
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      return credential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      bool status = false;
      await _firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) => status = true)
          .catchError((e) => status = false);
      return status;
    } catch (e) {
      throw Exception(e);
    }
  }
}
