part of 'note_bloc.dart';

abstract class NoteEvent{
  const NoteEvent();
}

class LoadedNote extends NoteEvent {
  final String uId;
  LoadedNote({required this.uId});
}

class AddNewNoteEvent extends NoteEvent {
  final String content;
  final String bookId;
  final String title;
  final String userId;

  const AddNewNoteEvent({
    required this.bookId,
    required this.content,
    required this.title,
    required this.userId,
  });
}
class RemoveNoteEvent extends NoteEvent {
  final String content;
  final String bookId;
  final String title;
  final String userId;
  final String noteId;

  const RemoveNoteEvent({
    required this.bookId,
    required this.content,
    required this.title,
    required this.userId,
    required this.noteId
  });
}
class EditNoteEvent extends NoteEvent {
  final String content;
  final String bookId;
  final String title;
  final String userId;
  final String noteId;

  const EditNoteEvent({
    required this.bookId,
    required this.content,
    required this.title,
    required this.userId,
    required this.noteId
  });
}
