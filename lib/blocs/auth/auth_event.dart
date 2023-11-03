part of'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthEventStarted extends AuthEvent {}
class AuthEventLoggedIn extends AuthEvent {
  final User authUser;
  const AuthEventLoggedIn(this.authUser);
  @override
  List<Object?> get props => [authUser];
}
class AuthEventLogOut extends AuthEvent {}
class AuthEventLoggedOut extends AuthEvent {}

