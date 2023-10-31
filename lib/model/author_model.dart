import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Author extends Equatable{

  final String id;
  final String fullName;

  const Author({required this.id, required this.fullName});

  static Author fromSnapshot(DocumentSnapshot snap) {
    Author author = Author(id: snap.id, fullName: snap['fullName']);
    return author;
  }
  @override
  List<Object?> get props => [id, fullName];

}