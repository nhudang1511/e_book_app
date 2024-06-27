import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';

abstract class BaseLibraryRepository{
  Future<void> addBookInLibrary(Library library);
  Future<void> removeBookInLibrary(Library library);
  Future<List<Library>> getAllLibraries();
  Future<List<Library>> getAllLibrariesByUid(String uId);
  Future<(List<Book>, DocumentSnapshot<Object?>?)> readBooksByLibrary(
      {int limit = 5,
        DocumentSnapshot<Object?>? startAfterDoc});
}