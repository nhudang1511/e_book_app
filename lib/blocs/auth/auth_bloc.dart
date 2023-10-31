import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authUserSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthEventStarted>(_onAuthEventStarted);
    on<AuthEventLoggedIn>(_onAuthEventLoggedIn);
    on<AuthEventLoggedOut>(_onAuthEventLoggedOut);
    _authUserSubscription = _authRepository.user.listen((User? authUser) {
      if (kDebugMode) {
        print("test $authUser");
      }
    });
  }

  void _onAuthEventStarted(
      AuthEventStarted event, Emitter<AuthState> emit) async {
    _authUserSubscription?.cancel();
    _authUserSubscription = _authRepository.user.listen((User? authUser) {
      if (authUser != null) {
        add(AuthEventLoggedIn(authUser));
      } else {
        add(AuthEventLoggedOut());
      }
    });
  }

  void _onAuthEventLoggedIn(
      AuthEventLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthenticateState(authUser: event.authUser));
  }

  void _onAuthEventLoggedOut(
      AuthEventLoggedOut event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(UnAuthenticateState());
  }
}
