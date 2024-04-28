import 'dart:async';
import 'package:e_book_app/exceptions/exceptions.dart';
import 'package:e_book_app/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repository/repository.dart';

part 'forgotPassword_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ForgotPasswordState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: ForgotPasswordStatus.initial,
      ),
    );
  }
  void reset() {
    emit(ForgotPasswordState.initial());
  }
  Future<void> forgotPassword() async {
    if (state.status == ForgotPasswordStatus.submitting) return;
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));
    try {
      await _authRepository.forgotPassword(email: state.email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          exception: e.message,
        ),
      );
    }
  }
}
