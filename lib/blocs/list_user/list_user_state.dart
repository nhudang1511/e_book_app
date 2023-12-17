part of'list_user_bloc.dart';

abstract class ListUserState extends Equatable{
  const ListUserState();
  @override
  List<Object?> get props => [];

}

class ListUserLoading extends ListUserState{
  @override
  List<Object?> get props => [];
}
class ListUserLoaded extends ListUserState{
  final List<User> users;

  const ListUserLoaded({this.users = const <User>[]});
  @override
  List<Object?> get props => [users];
}