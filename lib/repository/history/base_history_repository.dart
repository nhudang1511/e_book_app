import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryRepository{
  Future<void> addBookInHistory(History history);
  Future<List<History>> getAllHistories();
  Future<List<History>> getHistories(String bookId, String uId);
  Future<History> getHistoryByUId(String uId, String bookId);
}