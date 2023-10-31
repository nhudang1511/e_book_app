import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable{

  final String id;
  final String name;
  final bool status;
  final String imageUrl;

  const Category({required this.id, required this.name, required this.status, required this.imageUrl});

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      id: snap.id,
      name: snap['name'],
      status: snap['status'],
      imageUrl: snap['imageUrl']
    );
    return category;
  }
  @override
  List<Object?> get props => [id, name, status];

}