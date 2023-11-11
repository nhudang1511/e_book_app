part of 'editProfile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final String fullName;
  final String phoneNumber;
  final EditProfileStatus status;

  const EditProfileState({
    required this.fullName,
    required this.phoneNumber,
    required this.status,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      fullName: "",
      phoneNumber: "",
      status: EditProfileStatus.initial,
    );
  }

  EditProfileState copyWith({
    String? fullName,
    String? phoneNumber,
    EditProfileStatus? status,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [fullName, phoneNumber, status];
}
