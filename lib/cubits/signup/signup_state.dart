part of "signup_cubit.dart";

enum SignupStatus { initial, submitting, success, emailExists, error }

class SignupState extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  final SignupStatus status;

  const SignupState({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      fullName: "",
      phoneNumber: "",
      email: "",
      password: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? password,
    SignupStatus? status,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [fullName, phoneNumber, email, password, status];
}
