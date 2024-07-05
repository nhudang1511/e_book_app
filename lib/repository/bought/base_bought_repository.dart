import 'package:e_book_app/model/models.dart';
abstract class BaseBoughtRepository{
  Future<void> addBought(Bought bought);
  Future<Bought?> getBoughtById(String uId);
  Future<void> editBought(Bought bought);
}