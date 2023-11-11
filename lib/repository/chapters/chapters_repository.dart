import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/models.dart';
import 'base_chapters_repository.dart';

class ChaptersRepository extends BaseChaptersRepository{
  final FirebaseFirestore _firebaseFirestore;

  ChaptersRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<Chapters> getChapter(String bookId) {
    if (bookId.isEmpty) {
      // Throw an error if the bookId parameter is empty.
      throw Exception("The bookId parameter cannot be empty.");
    }
    return _firebaseFirestore
        .collection('chapters')
        .where('bookId', isEqualTo: bookId)
        .snapshots()
        .map((snapshot) => Chapters.fromSnapshot(snapshot.docs.first));
  }

}