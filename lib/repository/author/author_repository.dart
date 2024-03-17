import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/author_model.dart';
import 'package:e_book_app/repository/author/base_author_repository.dart';

class AuthorRepository extends BaseAuthorRepository{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<List<Author>> getAllAuthors() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('author').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Author().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Author> getAuthorById(String authorId) async {
    try {
      if(authorId.isNotEmpty){
        var docSnapshot = await _firebaseFirestore.collection('author').doc(authorId).get();
        if (docSnapshot.exists) {
          var data = docSnapshot.data()!;
          data['id'] = docSnapshot.id;
          return Author().fromJson(data);
        } else {
          throw Exception("Author with id $authorId does not exist");
        }
      }
      else{
        throw Error();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}