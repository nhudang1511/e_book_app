part of "signup_cubit.dart";

enum SignupStatus { initial, submitting, verifying, unVerify, success, error }

class SignupState extends Equatable {
  final String email;
  final String password;
  final SignupStatus status;
  final String? exception;

  const SignupState({
    required this.email,
    required this.password,
    required this.status,
    this.exception,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: "",
      password: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? email,
    String? password,
    SignupStatus? status,
    String? exception,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [email, password, status];
}
