import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
abstract class BaseBookRepository{
  Future<List<Book>> getAllBooks();
  Future<(List<Book>, DocumentSnapshot?)> readBooks({
    int limit = 5,
    DocumentSnapshot<Object?>? startAfterDoc
  });
  Future<void> fetchAuthorAndCategoryNames(Map<String, dynamic> data);
  Future<Book> getBookByBookId(String bookId);
}