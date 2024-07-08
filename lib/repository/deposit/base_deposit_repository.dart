import 'package:e_book_app/model/models.dart';
abstract class BaseDepositRepository{
  Future<void> addDeposit(Deposit deposit);
  Future<Deposit?> getDepositById(String uId);
  Future<void> editDeposit(Deposit deposit);
  Future<num> getTotalDeposits(String uId);
  Future<num> getTotalDepositsByMonth(String uId, DateTime month);
}