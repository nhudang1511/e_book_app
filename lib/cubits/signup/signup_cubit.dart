import 'dart:async';

import 'package:e_book_app/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  User? newUser;

  SignupCubit(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignupState.initial()) {}

  void fullNameChanged(String value) {
    emit(
      state.copyWith(
        fullName: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void phoneNumberChanged(String value) {
    emit(
      state.copyWith(
        phoneNumber: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignupStatus.initial,
      ),
    );
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      final credential = await _authRepository.signUp(
          email: state.email, password: state.password);
      if (credential != null) {
        await _userRepository.addUser(User(
            id: credential!.uid,
            fullName: state.fullName,
            email: state.email,
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=f9d5f654-f6b7-4f01-80e0-40cc22d5d183",
            passWord: state.password,
            phoneNumber: state.phoneNumber,
            status: true));
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        emit(state.copyWith(status: SignupStatus.error));
      }
    } catch (e) {
      if (e.toString() == 'Exception: email-already-in-use') {
        emit(state.copyWith(status: SignupStatus.emailExists));
      } else {
        emit(state.copyWith(status: SignupStatus.error));
      }
    }
  }
}
