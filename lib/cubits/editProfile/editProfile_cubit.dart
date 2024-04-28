import 'dart:async';
import 'dart:io';

import 'package:e_book_app/model/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:e_book_app/model/models.dart' as model;

part 'editProfile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  User? currentUser;

  EditProfileCubit(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(EditProfileState.initial());

  void fullNameChanged(String value) {
    emit(
      state.copyWith(
        fullName: value,
        status: EditProfileStatus.initial,
      ),
    );
  }

  void phoneNumberChanged(String value) {
    emit(
      state.copyWith(
        phoneNumber: value,
        status: EditProfileStatus.initial,
      ),
    );
  }

  void reset() {
    emit(EditProfileState.initial());
  }

  void fileAvatarChanged(File? value) {
    emit(
      state.copyWith(
        fileAvatar: value,
        status: EditProfileStatus.initial,
      ),
    );
  }

  Future<void> updateProfile() async {
    if (state.status == EditProfileStatus.submitting) return;
    emit(state.copyWith(status: EditProfileStatus.submitting));
    String imageUrl = '';
    try {
      if (state.fullName == '' &&
          state.phoneNumber == '' &&
          state.fileAvatar == null) {
        emit(
          state.copyWith(status: EditProfileStatus.initial),
        );
      } else {
        if (state.fileAvatar != null) {
          imageUrl = await _userRepository.uploadAvatar(
            fileAvatar: state.fileAvatar,
          );
        }
        var user = await _authRepository.updateProfile(
          state.fullName,
          state.phoneNumber,
          imageUrl,
        );
        await _userRepository.updateUser(model.User.fromFirebaseUser(user));
        emit(
          state.copyWith(status: EditProfileStatus.success),
        );
      }
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            fullName: '',
            phoneNumber: '',
            fileAvatar: null,
            status: EditProfileStatus.error),
      );
    }
  }
}
