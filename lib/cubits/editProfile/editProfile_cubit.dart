import 'dart:async';

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

  Future<void> updateProfire() async {
    if (state.status == EditProfileStatus.submitting) return;
    emit(state.copyWith(status: EditProfileStatus.submitting));
    if (state.fullName == '' && state.phoneNumber == '') {
      await _userRepository.updateUser(
        User(
          id: currentUser!.id,
          fullName: currentUser!.fullName,
          email: currentUser!.email,
          imageUrl: currentUser!.imageUrl,
          passWord: currentUser!.passWord,
          phoneNumber: currentUser!.phoneNumber,
          status: currentUser!.status,
        ),
      );
      emit(
        state.copyWith(status: EditProfileStatus.initial),
      );
    } else if (state.fullName == '') {
      await _userRepository.updateUser(
        User(
          id: currentUser!.id,
          fullName: currentUser!.fullName,
          email: currentUser!.email,
          imageUrl: currentUser!.imageUrl,
          passWord: currentUser!.passWord,
          phoneNumber: state.phoneNumber,
          status: currentUser!.status,
        ),
      );
      emit(
        state.copyWith(status: EditProfileStatus.success),
      );
    } else if (state.phoneNumber == '') {
      await _userRepository.updateUser(
        User(
          id: currentUser!.id,
          fullName: state.fullName,
          email: currentUser!.email,
          imageUrl: currentUser!.imageUrl,
          passWord: currentUser!.passWord,
          phoneNumber: currentUser!.phoneNumber,
          status: currentUser!.status,
        ),
      );
      emit(
        state.copyWith(status: EditProfileStatus.success),
      );
    } else {
      await _userRepository.updateUser(
        User(
          id: currentUser!.id,
          fullName: state.fullName,
          email: currentUser!.email,
          imageUrl: currentUser!.imageUrl,
          passWord: currentUser!.passWord,
          phoneNumber: state.phoneNumber,
          status: currentUser!.status,
        ),
      );
      emit(
        state.copyWith(status: EditProfileStatus.success),
      );
    }
  }
}
