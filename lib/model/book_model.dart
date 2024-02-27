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

  static Book fromJson(Map<String, dynamic> json) {
    Book book = Book(
        id: json['id'],
        authodId: json['authodId'],
        categoryId: List<String>.from(json['categoryId']),
        description: json['description'],
        imageUrl: json['imageUrl'],
        language: json['language'],
        price: json['price'],
        publishDate: (json['publishDate'] as Timestamp).toDate(),
        status: json['status'],
        title: json['title'],
        bookPreview: List<String>.from(json['bookPreview']),
        country: json['country'],
        chapters: json['chapters']
    );
    return book;
  }
}