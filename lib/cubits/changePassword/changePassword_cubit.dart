import 'dart:async';

import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'changePassword_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  User? currentUser;

  ChangePasswordCubit(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(ChangePasswordState.initial()) {
    _authRepository.user.listen((authUser) {
      _userRepository.getUser(authUser!.uid).listen((user) {
        currentUser = user;
      });
    });
  }

  void oldPasswordChanged(String value) {
    emit(
      state.copyWith(
        oldPassword: value,
        status: ChangePasswordStatus.initial,
      ),
    );
  }

  void newPasswordChanged(String value) {
    emit(
      state.copyWith(
        newPassword: value,
        status: ChangePasswordStatus.initial,
      ),
    );
  }

  void confirmNewPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmNewPassword: value,
        status: ChangePasswordStatus.initial,
      ),
    );
  }

  Future<void> changePassword() async {
    if (state.status == ChangePasswordStatus.submitting) return;
    emit(state.copyWith(status: ChangePasswordStatus.submitting));

    if (state.oldPassword == currentUser?.passWord) {
      final updatePassword =
          await _authRepository.changePassword(newPassword: state.newPassword);
      if (updatePassword == true) {
        emit(state.copyWith(status: ChangePasswordStatus.success));
        _userRepository.updateUser(
          User(
              id: currentUser!.id,
              fullName: currentUser!.fullName,
              email: currentUser!.email,
              imageUrl: currentUser!.imageUrl,
              passWord: state.newPassword,
              phoneNumber: currentUser!.phoneNumber,
              provider: currentUser!.provider,
              status: currentUser!.status),
        );
      } else {
        emit(state.copyWith(status: ChangePasswordStatus.error));
      }
    } else {
      emit(state.copyWith(status: ChangePasswordStatus.wrongPassword));
    }
  }
}
