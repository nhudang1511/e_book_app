import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_note_repository.dart';

class NoteRepository extends BaseNoteRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  NoteRepository();

  @override
  Future<List<Note>> getAllNote() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('notes').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Note().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addNote(Note note) {
    return _firebaseFirestore.collection('notes').add(note.toJson());
  }

  @override
  Future<void> removeNote(Note note) {
    return _firebaseFirestore.collection('notes').doc(note.noteId).delete();
  }

  @override
  Future<void> editNote(Note note) {
    return _firebaseFirestore
        .collection('notes')
        .doc(note.noteId)
        .update(note.toJson());
  }

  @override
  Future<List<Note>> getAllNoteById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('notes')
          .where('uId', isEqualTo: uId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Note().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
