import 'package:e_book_app/model/models.dart';

abstract class BaseLibraryRepository{
  Future<void> addBookInLibrary(Library library);
  Future<void> removeBookInLibrary(Library library);
  Stream<List<Library>> getAllLibraries();
}