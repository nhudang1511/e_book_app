import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
abstract class BaseBookRepository{
  Future<List<Book>> getBookByCategory(String cateId);
  Future<(List<Book>, DocumentSnapshot?)> readPosts({
    int limit = 5,
    DocumentSnapshot<Object?>? startAfterDoc,
    String? cateId
  });
  Future<void> fetchAuthorAndCategoryNames(Map<String, dynamic> data);
}