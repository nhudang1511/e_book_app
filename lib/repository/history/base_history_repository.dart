import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryRepository{
  Future<void> addBookInHistory(History history);
  Stream<List<History>> getAllHistories();
}