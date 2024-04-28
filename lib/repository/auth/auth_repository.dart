import 'dart:async';

import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/exceptions/exceptions.dart';
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
      if (credential.user != null) {
        return credential.user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw ServerException(ServerException.LOGIN_INCORRECT);
      } else if (e.code == 'user-disabled') {
        throw ServerException(ServerException.USER_DISABLE);
      } else if (e.code == 'too-many-requests') {
        throw ServerException(ServerException.TOO_MANY_REQUESTS);
      } else {
        throw ServerException(ServerException.LOGIN_FAILURE);
      }
    } catch (e) {
      throw ServerException(ServerException.LOGIN_FAILURE);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
      SharedService.clear();
    } catch (e) {
      throw ServerException(ServerException.LOGOUT_FAILURE);
    }
  }

  @override
  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw ServerException(ServerException.EMAIL_EXISTED);
      } else {
        throw ServerException(ServerException.SIGN_UP_FAILURE);
      }
    } catch (e) {
      throw ServerException(ServerException.SIGN_UP_FAILURE);
    }
  }

  @override
  Future<User?> logInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        SharedService.setUserId(userCredential.user!.uid);
      }
      return userCredential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User?> logInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: (["public_profile", "email"]));

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final credential =
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      if (credential.user != null) {
        SharedService.setUserId(credential.user!.uid);
      }
      return credential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ServerException(ServerException.EMAIL_NOT_EXIST);
      } else {
        throw ServerException(ServerException.FORGOT_PASSWORD_FAILUARE);
      }
    }
  }

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<bool> isVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      bool isVerified = _firebaseAuth.currentUser!.emailVerified;
      if (isVerified) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      bool isVerified = _firebaseAuth.currentUser!.emailVerified;
      if (!isVerified) {
        await _firebaseAuth.currentUser?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw ServerException(ServerException.TOO_MANY_REQUESTS);
      } else {
        rethrow;
      }
    } catch (e) {
      if (e.toString().contains('auth/too-many-requests')) {
        throw ServerException(ServerException.TOO_MANY_REQUESTS);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final userCurrent = _firebaseAuth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: userCurrent!.email!,
        password: oldPassword,
      );
      await userCurrent.reauthenticateWithCredential(credential);
      if (newPassword == oldPassword) {
        throw ServerException(ServerException.SAME_PASSWORD);
      }
      await userCurrent.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw ServerException(ServerException.WRONG_PASSWORD);
      } else {
        throw ServerException(ServerException.CHANGE_PASSWORD_FAILURE);
      }
    } on ServerException catch (e) {
      rethrow;
    } catch (e) {
      throw ServerException(ServerException.CHANGE_PASSWORD_FAILURE);
    }
  }

  @override
  Future<User> updateProfile(
    String? displayName,
    String? phoneNumber,
    String? avatar,
  ) async {
    try {
      if (displayName != '') {
        await _firebaseAuth.currentUser!.updateDisplayName(displayName);
      }
      if (phoneNumber != '') {
        await _firebaseAuth.currentUser!
            .updatePhoneNumber(phoneNumber as PhoneAuthCredential);
      }
      if (avatar != '') {
        await _firebaseAuth.currentUser!.updatePhotoURL(avatar);
      }
      await _firebaseAuth.currentUser!.reload();
      return _firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(ServerException.CHANGE_PROFILE_FAILURE);
    } catch (e) {
      throw ServerException(ServerException.CHANGE_PROFILE_FAILURE);
    }
  }
}
