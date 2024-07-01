part of 'deposit_bloc.dart';

abstract class DepositEvent{
  const DepositEvent();
}

class AddNewDepositEvent extends DepositEvent {
  final Deposit deposit;

  const AddNewDepositEvent({
    required this.deposit
  });
}
class LoadedDeposit extends DepositEvent {
  final String uId;
  LoadedDeposit({required this.uId});
}