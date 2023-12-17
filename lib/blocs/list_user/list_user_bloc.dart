import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';
import '../../repository/auth/auth_repository.dart';
import '../../repository/user/user_repository.dart';

part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _userSubscription;

  ListUserBloc(
      {required AuthRepository authRepository,
        required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(ListUserLoading()) {
    on<LoadListUser>(_onLoadListUser);
    on<UpdateListUser>(_onUpdateListUser);
  }
  void _onLoadListUser(event, Emitter<ListUserState> emit) async {
    _userSubscription?.cancel();
    _userSubscription = _userRepository
        .getAllUsers()
        .listen((event) => add(UpdateListUser(event)));
  }

  void _onUpdateListUser(event, Emitter<ListUserState> emit) async {
    emit(ListUserLoaded(users: event.users));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
