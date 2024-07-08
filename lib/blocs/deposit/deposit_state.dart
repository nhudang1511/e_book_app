part of 'deposit_bloc.dart';
abstract class DepositState {
  const DepositState();
}
class DepositInitial extends DepositState {
}
class DepositLoading extends DepositState{
}
class AddDeposit extends DepositState{
  final Deposit deposit;
  const AddDeposit({required this.deposit});
}
class DepositLoaded extends DepositState{
  final Deposit deposit;
  const DepositLoaded({required this.deposit});
}
class DepositCoinLoaded extends DepositState{
  final num depositCoin;
  const DepositCoinLoaded({required this.depositCoin});
}
class DepositError extends DepositState {
  final String error;

  const DepositError(this.error);
}