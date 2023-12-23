import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;

  Future<auth.User?> signUp({
    required String email,
    required String password,
  });

  Future<auth.User?> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<bool> changePassword({required String newPassword, required String oldPassword,});

  Future<auth.User?> logInWithGoogle();

  Future<auth.User?> logInWithFacebook();

  Future<bool> forgotPassword(String email);

}
