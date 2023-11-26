import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String imageUrl;
  final String passWord;
  final String phoneNumber;
  final String provider;
  final bool status;

  const User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.imageUrl,
      required this.passWord,
      required this.phoneNumber,
      required this.provider,
      required this.status});

  Map<String, Object> toDocument() {
    return {
      "fullName": fullName,
      "email": email,
      "imageUrl": imageUrl,
      "passWord": passWord,
      "phoneNumber": phoneNumber,
      "provider": provider,
      "status": status
    };
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
        id: snap.id,
        fullName: snap['fullName'],
        email: snap['email'],
        imageUrl: snap['imageUrl'],
        passWord: snap['passWord'],
        phoneNumber: snap['phoneNumber'],
        provider: snap['provider'],
        status: snap['status']);
    return user;
  }

  @override
  List<Object?> get props =>
      [id, fullName, email, imageUrl, passWord, phoneNumber, provider, status];
}
