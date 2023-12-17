part of'list_user_bloc.dart';

abstract class ListUserEvent extends Equatable {
  const ListUserEvent();
  @override
  List<Object?> get props => [];
}

class LoadListUser extends ListUserEvent {
  @override
  List<Object?> get props => [];
}
class UpdateListUser extends ListUserEvent{
  final List<User> users;
  const UpdateListUser(this.users);
  @override
  List<Object?> get props => [users];
}