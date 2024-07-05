import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_bought_repository.dart';

class BoughtRepository extends BaseBoughtRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> addBought(Bought bought) {
    return _firebaseFirestore.collection('bought').add(bought.toJson());
  }

  @override
  Future<Bought?> getBoughtById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('bought')
          .where('uId', isEqualTo: uId)
          .where('status', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return Bought().fromJson(data);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return null;
  }

  @override
  Future<void> editBought(Bought bought) {
    return _firebaseFirestore
        .collection('bought')
        .doc(bought.id)
        .update(bought.toJson());
  }
}
