import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/models.dart';
import '../../repository/chapters/chapters_repository.dart';
part 'chapters_event.dart';
part 'chapters_state.dart';

class ChaptersBloc extends Bloc<ChaptersEvent, ChaptersState> {
  final ChaptersRepository _chaptersRepository;
  StreamSubscription? _chapterSubscription;

  ChaptersBloc({required ChaptersRepository chaptersRepository})
      : _chaptersRepository = chaptersRepository, super(ChaptersLoading()){
        on<LoadChapters> (_onLoadChapters);
        on<UpdateChapters>(_onUpdateChapters);
  }
  void _onLoadChapters (event, emit) async{
    if (event.bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    _chapterSubscription?.cancel();
    _chapterSubscription = _chaptersRepository
        .getChapter(event.bookId)
        .listen((chapter) =>
        add(UpdateChapters(chapters: chapter)) );
  }
  void _onUpdateChapters (event, emit){
    emit(ChaptersLoaded(chapters: event.chapters));
  }
}
