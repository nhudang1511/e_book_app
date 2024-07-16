import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/book_model.dart';
import '../../model/models.dart';
import 'base_book_repository.dart';

class BookRepository extends BaseBookRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  BookRepository();

  @override
  Future<void> fetchAuthorAndCategoryNames(Map<String, dynamic> data) async {
    // Fetch the author data synchronously
    var authorDoc = await _firebaseFirestore
        .collection('author')
        .doc(data['authodId'])
        .get();

    if (authorDoc.exists) {
      data['authorName'] = authorDoc.get('fullName');
    } else {
      data['authorName'] =
          'Unknown Author'; // Handle the case when the author document does not exist
    }

    // Fetch category names
    List<String> categoryNames = [];
    if (data['categoryId'] != null && data['categoryId'] is List) {
      for (String categoryId in List<String>.from(data['categoryId'])) {
        var cateDoc = await _firebaseFirestore
            .collection('category')
            .doc(categoryId)
            .get();
        if (cateDoc.exists) {
          categoryNames.add(cateDoc.get('name'));
        }
      }
    }
    data['categoryName'] = categoryNames;
  }

  @override
  Future<(List<Book>, DocumentSnapshot<Object?>?)> readBooks(
      {int limit = 5, DocumentSnapshot<Object?>? startAfterDoc}) async {
    try {
      // 1) Query for documents with a limit.
      var query = _firebaseFirestore
          .collection("book")
          .where('status', isEqualTo: true)
          .orderBy("update_at", descending: true)
          .limit(limit);

      // 2) If paginating, then use the passed
      //    in document as the query cursor.
      final querySnapshot = startAfterDoc != null
          ? await query.startAfterDocument(startAfterDoc).get()
          : await query.get();

      // 3) If the number of fetched documents is equal to our limit,
      //    then we define the last document as the query cursor.
      final finalDoc =
          querySnapshot.docs.length == limit ? querySnapshot.docs.last : null;
      // 4) Return the fetched documents and query cursor.
      List<Book> books = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        await fetchAuthorAndCategoryNames(data);
        books.add(Book().fromJson(data));
      }

      return (books, finalDoc);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Book>> getAllBooks() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('book')
          .where('status', isEqualTo: true)
          .orderBy("update_at", descending: true)
          .get();

      List<Book> books = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        await fetchAuthorAndCategoryNames(data);
        books.add(Book().fromJson(data));
      }
      return books;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Book> getBookByBookId(String bookId) async {
    try {
      if (bookId.isNotEmpty) {
        var docSnapshot =
        await _firebaseFirestore.collection('book').doc(bookId).get();
        if (docSnapshot.exists) {
          var data = docSnapshot.data()!;
          data['id'] = docSnapshot.id;
          return Book().fromJson(data);
        } else {
          throw Exception("Book with id $bookId does not exist");
        }
      } else {
        throw Error();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
