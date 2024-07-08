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
  Future<num> getTotalDeposits(String uId) async {
    num totalCoins = 0;

    try {
      var querySnapshot = await _firebaseFirestore
          .collection('deposit')
          .where('uId', isEqualTo: uId)
          .where('status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var data = doc.data();
          totalCoins += data['coin'] ?? 0;
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return totalCoins;
  }

  @override
  Future<void> editDeposit(Deposit deposit) {
    return _firebaseFirestore
        .collection('deposit')
        .doc(deposit.id)
        .update(deposit.toJson());
  }

  @override
  Future<num> getTotalDepositsByMonth(String uId, DateTime month) async {
    num totalCoins = 0;

    try {
      var startOfMonth = DateTime(month.year, month.month,1);
      var endOfMonth = DateTime(month.year, month.month + 1, 1);
      // Lấy dữ liệu từ Firestore với điều kiện uId và updatedAt có tháng/năm tương ứng
      var querySnapshot = await _firebaseFirestore
          .collection('deposit')
          .where('uId', isEqualTo: uId)
          .where('status', isEqualTo: false)
          .where('updateAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('updateAt', isLessThan: Timestamp.fromDate(endOfMonth))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var data = doc.data();
          totalCoins += data['coin'] ?? 0;
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return totalCoins;
  }
}
