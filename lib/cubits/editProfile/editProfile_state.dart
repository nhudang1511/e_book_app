part of 'editProfile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final String fullName;
  final String phoneNumber;
  final File? fileAvatar;
  final EditProfileStatus status;

  const EditProfileState({
    this.fileAvatar,
    required this.fullName,
    required this.phoneNumber,
    required this.status,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      fullName: "",
      phoneNumber: "",
      fileAvatar: null,
      status: EditProfileStatus.initial,
    );
  }

  EditProfileState copyWith({
    String? fullName,
    String? phoneNumber,
    File? fileAvatar,
    EditProfileStatus? status,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fileAvatar: fileAvatar ?? this.fileAvatar,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [fullName, phoneNumber, fileAvatar, status];
}
