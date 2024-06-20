import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
abstract class BaseBookRepository{
  Future<List<Book>> getAllBooks();
  Future<List<Book>> getBookByCategory(String cateId);
}