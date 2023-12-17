import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_book_app/model/models.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  UserRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }
  @override
  Stream<List<User>> getAllUsers() {
    return _firebaseFirestore
        .collection('user')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateUser(User user) async {
    await _firebaseFirestore
        .collection('user')
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<void> addUser(User user) async {
    await _firebaseFirestore
        .collection('user')
        .doc(user.id)
        .set(user.toDocument());
  }

  @override
  Future<String> uploadAvatar(File? fileAvatar) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final ref = _firebaseStorage.ref().child("avatar_user/$fileName.jpg");
      await ref.putFile(
          fileAvatar!, SettableMetadata(contentType: 'image/jpeg'));

      final url = await ref.getDownloadURL();
      return url.toString();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> removeOldAvatar(String imageUrl) async {
    await _firebaseStorage.refFromURL(imageUrl).delete();
  }

  @override
  Future<bool> getUserByEmail(String? email) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("user")
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
