import '../../model/user_model.dart';

abstract class BaseUserRepository {
  Stream<List<User>> getUser();
}