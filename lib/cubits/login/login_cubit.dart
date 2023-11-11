import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: LoginStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final credential = await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      if (credential != null) {
        emit(state.copyWith(status: LoginStatus.success));
      }
      else {
        emit(state.copyWith(status: LoginStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
