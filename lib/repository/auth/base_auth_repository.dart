import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Future<auth.User?> signUp({
    required String email,
    required String password,
  });

  Future<auth.User?> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<auth.User?> logInWithGoogle();

  Future<auth.User?> logInWithFacebook();

  Future<void> forgotPassword({
    required String email,
  });

  Stream<auth.User?> get user;

  Future<bool> isVerified();

  Future<void> sendEmailVerification();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<auth.User> updateProfile(
    String? displayName,
    String? phoneNumber,
    String? avatar,
  );
}
