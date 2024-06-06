part of 'note_bloc.dart';
abstract class NoteState {
  const NoteState();
}
class NoteInitial extends NoteState {
}
class NoteLoading extends NoteState{
}
class NoteLoaded extends NoteState{
  final List<Note> notes;
  const NoteLoaded({this.notes = const <Note>[]});
}
class AddNote extends NoteState{
  final Note note;
  const AddNote({required this.note});
}
class NoteError extends NoteState {
  final String error;

  const NoteError(this.error);
}