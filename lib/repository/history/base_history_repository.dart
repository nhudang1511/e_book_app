import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryRepository{
  Future<History> addBookInHistory(History history);
  Future<List<History>> getHistories(String bookId, String uId);
  Future<History> getHistoryByUId(String uId, String bookId);
  Stream<QuerySnapshot> streamHistories(String uId);
  Stream<QuerySnapshot> streamHistoriesByUId(String uId, String bookId);
  Future<History> removeItemInHistory(History history);
  Stream<QuerySnapshot> streamAllHistories();
}