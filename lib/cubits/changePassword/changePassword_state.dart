part of 'changePassword_cubit.dart';

enum ChangePasswordStatus { initial, submitting, success, error }

class ChangePasswordState extends Equatable {
  final String oldPassword;
  final String newPassword;
  final ChangePasswordStatus status;
  final String? exception;

  const ChangePasswordState({
    required this.oldPassword,
    required this.newPassword,
    required this.status,
    this.exception,
  });

  factory ChangePasswordState.initial() {
    return const ChangePasswordState(
      oldPassword: '',
      newPassword: '',
      status: ChangePasswordStatus.initial,
    );
  }

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    ChangePasswordStatus? status,
    String? exception,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [oldPassword, newPassword, status];
}
