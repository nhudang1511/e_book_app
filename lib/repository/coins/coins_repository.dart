import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/coins_model.dart';

import 'base_coins_repository.dart';

class CoinsRepository extends BaseCoinsRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CoinsRepository();

  @override
  Future<void> addCoins(Coins coins) {
    return _firebaseFirestore.collection('coins').add(coins.toJson());
  }

  @override
  Future<Coins> getCoinsById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('coins')
          .where('uId', isEqualTo: uId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var coinsData = querySnapshot.docs.first.data();
        coinsData['id'] = querySnapshot.docs.first.id;
        return Coins().fromJson(coinsData);
      }
      else{
        return Coins();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  @override
  Future<void> editCoins(Coins coins) {
    return _firebaseFirestore
        .collection('coins')
        .doc(coins.coinsId)
        .update(coins.toJson());
  }
}