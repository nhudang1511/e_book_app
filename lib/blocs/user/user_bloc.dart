// import 'dart:async';
//
// import 'package:e_book_app/model/models.dart';
// import 'package:e_book_app/repository/repository.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
//
// part 'user_event.dart';
//
// part 'user_state.dart';
//
// class UserBloc extends Bloc<UserEvent, UserState> {
//   final AuthRepository _authRepository;
//   final UserRepository _userRepository;
//   StreamSubscription? _authSubscription;
//
//   UserBloc(
//       {required AuthRepository authRepository,
//         required UserRepository userRepository})
//       : _authRepository = authRepository,
//         _userRepository = userRepository,
//         super(UserLoading()) {
//     on<LoadUser>(_onLoadUser);
//     on<UpdateUser>(_onUpdateUser);
//   }
//
//   void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
//     _authSubscription = _authRepository.user.listen((auth.User? authUser) async {
//       if (authUser != null) {
//         var user = await _userRepository.getProfile(user: authUser);
//         add(UpdateUser(user!));
//       }
//     });
//   }
//
//   void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
//     emit(UserLoaded(user: event.user));
//   }
//
//
//   @override
//   Future<void> close() {
//     _authSubscription?.cancel();
//     return super.close();
//   }
// }