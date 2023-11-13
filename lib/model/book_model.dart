import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Book extends Equatable{
  final String id;
  final String authodId;
  final List<String> categoryId;
  final String description;
  final String imageUrl;
  final String language;
  final int price;
  final DateTime publishDate;
  final bool status;
  final String title;
  final List<String> bookPreview;
  final int chapters;
  final String country;

  const Book({
    required this.id,
    required this.authodId,
    required this.categoryId,
    required this.description,
    required this.imageUrl,
    required this.language,
    required this.price,
    required this.publishDate,
    required this.status,
    required this.title,
    required this.bookPreview,
    required this.chapters,
    required this.country
  });

  @override
  List<Object?> get props =>[authodId, categoryId, description, imageUrl,
    language, price, publishDate, status, title, bookPreview, chapters, country];

  static Book fromSnapshot(DocumentSnapshot snap) {
    Book book = Book(
        id: snap.id, authodId: snap['authodId'],
        categoryId: List<String>.from(snap['categoryId']),
        description: snap['description'],
        imageUrl: snap['imageUrl'],
        language: snap['language'],
        price: snap['price'],
        publishDate: (snap['publishDate'] as Timestamp).toDate(),
        status: snap['status'],
        title: snap['title'],
        bookPreview: List<String>.from(snap['bookPreview']),
        country: snap['country'],
        chapters: snap['chapters']
    );
    return book;
  }
}