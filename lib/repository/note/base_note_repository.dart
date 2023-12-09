import 'package:e_book_app/model/models.dart';
abstract class BaseNoteRepository{
  Stream<List<Note>> getAllNote();
  Future<void> addNote(Note note);
}