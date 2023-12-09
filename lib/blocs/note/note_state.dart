part of 'note_bloc.dart';
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}
class NoteInitial extends NoteState {
  @override
  List<Object?> get props => [];
}
class NoteLoading extends NoteState{
  @override
  List<Object?> get props => [];
}
class NoteLoaded extends NoteState{
  final List<Note> notes;
  const NoteLoaded({this.notes = const <Note>[]});
  @override
  List<Object?> get props => [notes];
}
class NoteError extends NoteState {
  final String error;

  const NoteError(this.error);

  @override
  List<Object?> get props => [error];
}