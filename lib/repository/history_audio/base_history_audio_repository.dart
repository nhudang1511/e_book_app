import 'package:e_book_app/model/models.dart';

abstract class BaseHistoryAudioRepository{
  Future<HistoryAudio> addBookInHistoryAudio(HistoryAudio historyAudio);
  Future<List<HistoryAudio>> getHistoryAudio(String bookId, String uId);
}