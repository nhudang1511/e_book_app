import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String imageUrl;
  final String passWord;
  final int phoneNumber;
  final bool status;

  const User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.imageUrl,
      required this.passWord,
      required this.phoneNumber,
      required this.status});

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
        id: snap.id,
        fullName: snap['fullName'],
        email: snap['email'],
        imageUrl: snap['imageUrl'],
        passWord: snap['passWord'],
        phoneNumber: snap['phoneNumber'],
        status: snap['status']);
    return user;
  }

  @override
  List<Object?> get props =>
      [id, fullName, email, imageUrl, passWord, phoneNumber, status];
}
