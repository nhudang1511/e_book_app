import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/models.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser(User user) async {
    final data = {
      "email": user.email,
      "fullName": user.fullName,
      "imageUrl": user.imageUrl,
      "passWord": user.passWord,
      "phoneNumber": user.phoneNumber,
      "status": user.status
    };
    await _firebaseFirestore.collection('user').doc(user.id).update(data);
  }
}
