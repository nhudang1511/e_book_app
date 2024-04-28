part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final User? authUser;
  const AuthState({this.authUser});

  @override
  List<Object?> get props => [authUser];
}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState {
  const AuthenticateState({super.authUser});

  @override
  List<Object?> get props => [authUser];

  @override
  String toString() {
    return 'AuthenticateState{authUser: ${authUser?.email}}';
  }
}

class UnAuthenticateState extends AuthState {}