part of 'forgotPassword_cubit.dart';

enum ForgotPasswordStatus { initial, submitting, success, error }

class ForgotPasswordState extends Equatable {
  final String email;
  final ForgotPasswordStatus status;
  final String? exception;

  const ForgotPasswordState(
      {required this.email, required this.status, this.exception});

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
        email: '', status: ForgotPasswordStatus.initial);
  }

  ForgotPasswordState copyWith({
    String? email,
    ForgotPasswordStatus? status,
    String? exception,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [email, status];
}
