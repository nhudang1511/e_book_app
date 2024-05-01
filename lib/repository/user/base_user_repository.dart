import 'dart:io';

import 'package:e_book_app/model/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


abstract class BaseUserRepository {

  Future<List<User>> getAllUsers();

  Future<void> uploadAvatar({required File? fileAvatar});

  Future<User?> getProfile({required auth.User user});
  Future<void> updateUser(User user);
  Future<void> addUser(User user);
}
