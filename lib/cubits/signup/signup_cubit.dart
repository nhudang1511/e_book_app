import 'dart:async';

import 'package:e_book_app/exceptions/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:e_book_app/model/models.dart' as model;
import 'package:firebase_messaging/firebase_messaging.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  Timer? timer;

  SignupCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignupState.initial());

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
        email: state.email,
        password: state.password,
      );
      if (credential != null) {
        verifyAccount(credential);
      } else {
        emit(
          state.copyWith(
            status: SignupStatus.error,
            exception: 'Sign up failed.',
          ),
        );
      }
    } on ServerException catch (e) {
      emit(state.copyWith(
        status: SignupStatus.error,
        exception: e.message,
      ));
    }
  }

  Future<void> verifyAccount(User credential) async {
    late String? deviceToken;
    if (state.status == SignupStatus.verifying) return;
    emit(state.copyWith(status: SignupStatus.verifying));
    try {
      timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        final isVerified = await _authRepository.isVerified();
        if (isVerified) {
          timer?.cancel();
          await _userRepository
              .addUser(model.User.fromFirebaseUser(credential));
          deviceToken = await FirebaseMessaging.instance.getToken();
          _userRepository.updateDeviceToken(credential.uid, deviceToken!);
          emit(state.copyWith(status: SignupStatus.success));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          status: SignupStatus.error, exception: 'Verification error.'));
    }
  }

  Future<void> unVerifyAccount() async {
    timer?.cancel();
    emit(state.copyWith(status: SignupStatus.unVerify));
  }

  Future<void> sendEmailVerification() async {
    try {
      await _authRepository.sendEmailVerification();
    } catch (_) {}
  }
}
