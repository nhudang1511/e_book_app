part of 'changePassword_cubit.dart';

enum ChangePasswordStatus { initial, submitting, success, wrongPassword, error }

class ChangePasswordState extends Equatable {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;
  final ChangePasswordStatus status;

  const ChangePasswordState({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
    required this.status,
  });

  factory ChangePasswordState.initial() {
    return const ChangePasswordState(
      oldPassword: '',
      newPassword: '',
      confirmNewPassword: '',
      status: ChangePasswordStatus.initial,
    );
  }

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? confirmNewPassword,
    ChangePasswordStatus? status,
  }) {
    return ChangePasswordState(
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
        confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmNewPassword, status];
}
