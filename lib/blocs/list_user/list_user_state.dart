part of'list_user_bloc.dart';

abstract class ListUserState{
  const ListUserState();
}

class ListUserLoading extends ListUserState{
}
class ListUserLoaded extends ListUserState{
  final List<User> users;

  const ListUserLoaded({this.users = const <User>[]});
}
class ListUserError extends ListUserState {
  final String error;

  const ListUserError(this.error);
}