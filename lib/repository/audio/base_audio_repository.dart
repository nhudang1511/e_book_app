import '../../model/models.dart';
abstract class BaseAudioRepository{
  Future<Audio?> getChaptersAudio(String bookId);
}