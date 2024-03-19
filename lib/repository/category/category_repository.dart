import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/category_model.dart';
import 'base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CategoryRepository();

  @override
  Future<List<Category>> getAllCategory() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('category')
          .where('status', isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Category().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
