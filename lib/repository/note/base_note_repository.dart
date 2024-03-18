import 'package:e_book_app/model/models.dart';
abstract class BaseNoteRepository{
  Future<List<Note>> getAllNote();
  Future<void> addNote(Note note);
  Future<void> removeNote(Note note);
  Future<void> editNote(Note note);
  Future<List<Note>> getAllNoteById(String uId);
}