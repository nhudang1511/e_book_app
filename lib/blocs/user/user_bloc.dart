import 'dart:async';

import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState>{
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _userSubscription;

  UserBloc({required AuthRepository authRepository, required UserRepository userRepository}): _authRepository = authRepository, _userRepository = userRepository, super(UserLoading()){
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<LoadListUser>(_onLoadListUser);
    on<UpdateListUser>(_onUpdateListUser);
  }
  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    _authSubscription = _authRepository.user.listen((auth.User? authUser) {
      if(authUser!=null) {
        _userSubscription = _userRepository.getUser(authUser.uid).listen((user) {
          add(UpdateUser(user!));
        });
      }
    });
  }
  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoaded(user: event.user));
  }
  void _onLoadListUser(event, Emitter<UserState> emit) async{
    _userSubscription?.cancel();
    _userSubscription =
        _userRepository
            .getAllUsers()
            .listen((event) => add(UpdateListUser(event)));
  }
  void _onUpdateListUser(event, Emitter<UserState> emit) async{
    emit(ListUserLoaded(users: event.users));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
