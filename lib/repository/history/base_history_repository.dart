import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryRepository{
  Future<History> addBookInHistory(History history);
  Future<List<History>> getAllHistories();
  Future<List<History>> getHistories(String bookId, String uId);
  Future<History> getHistoryByUId(String uId, String bookId);
  Future<(List<History>,List<Book>, DocumentSnapshot<Object?>?)> getBooksInHistories(
      {int limit = 5,
        DocumentSnapshot<Object?>? startAfterDoc});
}