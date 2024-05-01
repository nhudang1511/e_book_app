part of'list_user_bloc.dart';

abstract class ListUserEvent{
  const ListUserEvent();
}

class LoadListUser extends ListUserEvent {
}
class UpdateListUser extends ListUserEvent{
  final List<User> users;
  const UpdateListUser(this.users);}