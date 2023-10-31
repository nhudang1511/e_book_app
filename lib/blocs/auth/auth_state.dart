part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState {
  final User authUser;
  const AuthenticateState({required this.authUser});

  @override
  List<Object?> get props => [authUser];

  @override
  String toString() {
    return 'AuthenticateState{authUser: ${authUser?.email}}';
  }
}

class UnAuthenticateState extends AuthState {}
