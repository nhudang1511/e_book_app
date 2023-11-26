import 'dart:async';

import 'package:e_book_app/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
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
      } else {
        emit(state.copyWith(status: LoginStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> logInWithGoogle() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final credential = await _authRepository.logInWithGoogle();
      if (credential != null) {
        final user = await _userRepository.getUserByEmail(credential.email);
        if (user == false) {
          await _userRepository.addUser(User(
              id: credential.uid,
              fullName: credential.displayName!,
              email: credential.email!,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=8389d86c-b1bf-4af6-ad6f-a09f41ce7c44",
              passWord: '',
              phoneNumber: '',
              provider: 'google',
              status: true));
        }
        emit(state.copyWith(status: LoginStatus.success));
      }
    } catch (e) {
      print("loginwithgoogle ${e.toString()}");
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> logInWithFacebook() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final credential = await _authRepository.logInWithFacebook();
      if (credential != null) {
        final user = await _userRepository.getUserByEmail(credential.email);
        if (user == false) {
          await _userRepository.addUser(
            User(
                id: credential.uid,
                fullName: credential.displayName!,
                email: credential.email!,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/flutter-e-book-app.appspot.com/o/avatar_user%2Fdefault_avatar.png?alt=media&token=8389d86c-b1bf-4af6-ad6f-a09f41ce7c44",
                passWord: '',
                phoneNumber: '',
                provider: 'facebook',
                status: true),
          );
        }
      }
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      if (e.toString() ==
          'Exception: [firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.') {
        emit(state.copyWith(status: LoginStatus.emailDiffProvider));
      } else {
        emit(state.copyWith(status: LoginStatus.error));
      }
    }
  }
}
