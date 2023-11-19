import 'dart:async';
import 'dart:io';

import 'package:e_book_app/model/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/repository/repository.dart';

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
        super(EditProfileState.initial()) {
    _authRepository.user.listen((authUser) {
      _userRepository.getUser(authUser!.uid).listen((user) {
        currentUser = user;
      });
    });
  }

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
          if (currentUser?.imageUrl !=
              'https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=8389d86c-b1bf-4af6-ad6f-a09f41ce7c44') {
            await _userRepository.removeOldAvatar(currentUser!.imageUrl);
          }
          imageUrl = await _userRepository.uploadAvatar(state.fileAvatar);
        }
        await _userRepository.updateUser(
          User(
            id: currentUser!.id,
            fullName:
                state.fullName == '' ? currentUser!.fullName : state.fullName,
            email: currentUser!.email,
            imageUrl:
                state.fileAvatar == null ? currentUser!.imageUrl : imageUrl,
            passWord: currentUser!.passWord,
            phoneNumber: state.phoneNumber == ''
                ? currentUser!.phoneNumber
                : state.phoneNumber,
            status: currentUser!.status,
          ),
        );
        emit(
          state.copyWith(status: EditProfileStatus.success),
        );
      }
    } catch (e) {
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
