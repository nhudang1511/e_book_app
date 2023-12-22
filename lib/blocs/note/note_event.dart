part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadedNote extends NoteEvent {
  @override
  List<Object?> get props => [];
}

class UpdateNote extends NoteEvent {
  final List<Note> notes;

  const UpdateNote(this.notes);

  @override
  List<Object?> get props => [notes];
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

  @override
  List<Object?> get props => [bookId, content, title, userId];
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
  @override
  List<Object?> get props => [bookId, content, title, userId, noteId];
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
  @override
  List<Object?> get props => [bookId, content, title, userId, noteId];
}
