// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
//
// class User extends Equatable {
//   final String id;
//   final String fullName;
//   final String email;
//   final String imageUrl;
//   final String passWord;
//   final String phoneNumber;
//   final String provider;
//   final bool status;
//
//   const User(
//       {required this.id,
//       required this.fullName,
//       required this.email,
//       required this.imageUrl,
//       required this.passWord,
//       required this.phoneNumber,
//       required this.provider,
//       required this.status});
//
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;

  // final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  final bool? status;

  const User({
    this.status = true,
    required this.uid,
    required this.email,
    // this.phoneNumber,
    this.displayName,
    this.photoURL,
  });

  factory User.fromFirebaseUser(auth.User user) {
    return User(
      uid: user.uid,
      email: user.email!,
      // phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  Map<String, Object?> toDocument() {
    Map<String, Object?> document = {
      "email": email,
      "status": status,
    };
    if (displayName != null) {
      document["displayName"] = displayName;
    }

    if (photoURL != null) {
      document["photoURL"] = photoURL;
    }
    return document;
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
      uid: snap.id,
      displayName: snap['displayName'],
      email: snap['email'],
      photoURL: snap['photoURL'],
      // phoneNumber: snap['phoneNumber'],
    );
    return user;
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoURL,
      ];
}
