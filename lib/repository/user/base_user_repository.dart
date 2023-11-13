import '../../model/user_model.dart';

abstract class BaseUserRepository {
  Stream<User> getUser(String userId);
  Future<void> updateUser(User user);
  Future<void> addUser(User user);
}