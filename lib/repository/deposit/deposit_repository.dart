import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/models.dart';
import 'base_deposit_repository.dart';

class DepositRepository extends BaseDepositRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> addDeposit(Deposit deposit) {
    return _firebaseFirestore.collection('deposit').add(deposit.toJson());
  }

  @override
  Future<Deposit?> getDepositById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('deposit')
          .where('uId', isEqualTo: uId)
          .where('status', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return Deposit().fromJson(data);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return null;
  }

  @override
  Future<void> editDeposit(Deposit deposit) {
    return _firebaseFirestore
        .collection('deposit')
        .doc(deposit.id)
        .update(deposit.toJson());
  }
}
