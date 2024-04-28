part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, verifying, unVerify, success, error}

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final String? exception;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.exception,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? exception,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
