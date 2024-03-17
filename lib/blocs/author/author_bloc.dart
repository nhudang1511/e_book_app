import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/author_model.dart';
import '../../repository/author/author_repository.dart';
part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorRepository _authorRepository;
  AuthorBloc(this._authorRepository)
      :super(AuthorLoading()){
    on<LoadedAllAuthor>(_onLoadedAllAuthor);
    on<LoadedAuthor>(_onLoadedAuthor);
  }

  void _onLoadedAllAuthor(event, Emitter emit) async{
    try {
      List<Author> author = await _authorRepository.getAllAuthors();
      emit(AuthorAllLoaded(authors: author));
    } catch (e) {
      emit(AuthorFailure());
    }
  }

  void _onLoadedAuthor(event, Emitter emit) async{
    try {
      Author author = await _authorRepository.getAuthorById(event.authorId);
      emit(AuthorLoaded(author));
    } catch (e) {
      emit(AuthorFailure());
    }
  }
}
