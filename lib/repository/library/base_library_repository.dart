import 'package:e_book_app/model/models.dart';

abstract class BaseLibraryRepository{
  Future<void> addBookInLibrary(Library library);
  Future<void> removeBookInLibrary(Library library);
  Future<List<Library>> getAllLibraries();
  Future<List<Library>> getAllLibrariesByUid(String uId);
}