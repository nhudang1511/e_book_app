import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_history_repository.dart';

class HistoryRepository extends BaseHistoryRepository{

  final FirebaseFirestore _firebaseFirestore;

  HistoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addBookInHistory(History history) {
    return _firebaseFirestore.collection('histories').add(history.toDocument());
  }

  @override
  Stream<List<History>> getAllHistories() {
    return _firebaseFirestore
        .collection('histories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => History.fromSnapshot(doc)).toList();
    });
  }

}