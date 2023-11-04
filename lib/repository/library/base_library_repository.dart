import 'package:e_book_app/model/models.dart';

abstract class BaseLibraryRepository{
  Future<void> addBookInLibrary(Library library);
}