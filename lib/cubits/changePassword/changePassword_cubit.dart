import 'dart:async';

import 'package:e_book_app/exceptions/exceptions.dart';
import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'changePassword_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(ChangePasswordState.initial());

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

  Future<void> changePassword() async {
    if (state.status == ChangePasswordStatus.submitting) return;
    emit(state.copyWith(status: ChangePasswordStatus.submitting));
    try {
      await _authRepository.changePassword(
          newPassword: state.newPassword, oldPassword: state.oldPassword);
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } on ServerException catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.error,
        exception: e.message,
      ));
    }
  }
}
