part of'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthEventStarted extends AuthEvent {}
class AuthEventChanged extends AuthEvent {
  final User? authUser;
  const AuthEventChanged(this.authUser);
  @override
  List<Object?> get props => [authUser];
}
class AuthEventLoggedOut extends AuthEvent {}



