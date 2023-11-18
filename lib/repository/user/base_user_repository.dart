import 'dart:io';

import '../../model/user_model.dart';

abstract class BaseUserRepository {
  Stream<User> getUser(String userId);
  Future<void> updateUser(User user);
  Future<void> addUser(User user);
  Future<String> uploadAvatar(File fileAvatar);
  Future<void> removeOldAvatar (String imageUrl);
}