import 'package:e_book_app/model/models.dart';
abstract class BaseCoinsRepository{
  Future<void> addCoins(Coins coins);
  Future<Coins> getCoinsById(String uId);
  Future<void> editCoins(Coins coins);
}