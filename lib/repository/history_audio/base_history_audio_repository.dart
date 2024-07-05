import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryAudioRepository{
  Future<HistoryAudio> addBookInHistoryAudio(HistoryAudio historyAudio);
  Future<List<HistoryAudio>> getHistoryAudio(String bookId, String uId);
  Future<List<HistoryAudio>> getAllHistoryAudio();
  Stream<QuerySnapshot> streamHistoriesAudio(String uId);
}