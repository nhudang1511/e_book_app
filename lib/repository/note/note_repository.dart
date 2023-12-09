import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_note_repository.dart';

class NoteRepository extends BaseNoteRepository{

  final FirebaseFirestore _firebaseFirestore;

  NoteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<Note>> getAllNote() {
    return _firebaseFirestore
        .collection('notes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> addNote(Note note) {
    return _firebaseFirestore.collection('notes').add(note.toDocument());
  }

}