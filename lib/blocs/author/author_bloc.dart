import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../model/author_model.dart';
import '../../repository/author/author_repository.dart';
part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorRepository _authorRepository;
  StreamSubscription? _authorSupscription;
  AuthorBloc({required AuthorRepository authorRepository})
      : _authorRepository = authorRepository,
        super(AuthorLoading()){
    on<LoadedAuthor>(_onLoadedAuthor);
    on<UpdateAuthor>(_onUpdateAuthor);
  }

  void _onLoadedAuthor(event, Emitter emit) async{
    _authorSupscription?.cancel();
    _authorSupscription = _authorRepository
        .getAllAuthors()
        .listen((event) => add(UpdateAuthor(event)));
  }
  void _onUpdateAuthor(event, Emitter emit) async{
    emit(AuthorLoaded(authors: event.authors));
  }
}
