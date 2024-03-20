import 'package:e_book_app/model/library_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';
part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _libraryRepository;

  LibraryBloc(this._libraryRepository)
      :super(LibraryInitial()){
    on<AddToLibraryEvent>(_onAddToLibrary);
    on<RemoveFromLibraryEvent>(_onRemoveFromLibrary);
    on<LoadLibrary>(_onLoadLibrary);
    on<LoadLibraryByUid>(_onLoadLibraryByUid);
  }
  void _onAddToLibrary(event, Emitter<LibraryState> emit) async{
    final library = Library(bookId: event.bookId, userId: event.userId);
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
    final library = Library(bookId: event.bookId, userId: event.userId);
    emit(LibraryLoading());
    try {
      // Thêm sách vào thư viện
      await _libraryRepository.removeBookInLibrary(library);
      emit(LibraryLoaded(libraries: event.libraries));
    } catch (e) {
      emit(LibraryError('error in add'));
    }
  }
  void _onLoadLibrary(event, Emitter<LibraryState> emit) async{
    try {
      List<Library> library = await _libraryRepository.getAllLibraries();
      emit(LibraryLoaded(libraries: library));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  void _onLoadLibraryByUid(event, Emitter<LibraryState> emit) async{
    try {
      List<Library> library = await _libraryRepository.getAllLibrariesByUid(event.userId);
      emit(LibraryLoaded(libraries: library));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }
}