import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../repository/user/user_repository.dart';

part 'list_user_event.dart';
part 'list_user_state.dart';

class ListUserBloc extends Bloc<ListUserEvent, ListUserState> {
  final UserRepository _userRepository;

  ListUserBloc(this._userRepository):
        super(ListUserLoading()) {
    on<LoadListUser>(_onLoadListUser);
  }
  void _onLoadListUser(event, Emitter<ListUserState> emit) async {
    try {
      List<User> user = await _userRepository.getAllUsers();
      emit(ListUserLoaded(users: user));
    } catch (e) {
      emit(ListUserError(e.toString()));
    }
  }
}
