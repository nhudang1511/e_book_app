import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_book_app/model/library_model.dart';
import 'package:equatable/equatable.dart';
import '../../repository/repository.dart';
part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _libraryRepository;
  StreamSubscription? _librarySubscription;

  LibraryBloc({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository,
        super(LibraryInitial()){
    on<AddToLibraryEvent>(_onAddToLibrary);
    on<RemoveFromLibraryEvent>(_onRemoveFromLibrary);
    on<LoadLibrary>(_onLoadLibrary);
    on<UpdateLibrary>(_onUpdateLibrary);
  }
  void _onAddToLibrary(event, Emitter<LibraryState> emit) async{
    final library = Library(bookId: event.bookId, userId: event.userId);
    _librarySubscription?.cancel();
    emit(LibraryLoading());
    try {
      // Thêm sách vào thư viện
      await _libraryRepository.addBookInLibrary(library);
      emit(LibraryLoaded(libraries: event.libraries));
    } catch (e) {
      emit(LibraryError('error in add'));
    }
  }
  void _onRemoveFromLibrary(event, Emitter<LibraryState> emit) async{
  }
  void _onLoadLibrary(event, Emitter<LibraryState> emit) async{
    emit(LibraryLoading());
    _librarySubscription?.cancel();
    _librarySubscription =
        _libraryRepository
            .getAllLibrries()
            .listen((event) => add(UpdateLibrary(event)));
  }
  void _onUpdateLibrary(event, Emitter<LibraryState> emit) async{
    emit(LibraryLoaded(libraries: event.libraries));
  }
}