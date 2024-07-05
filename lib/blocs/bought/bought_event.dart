part of 'bought_bloc.dart';

abstract class BoughtEvent{
  const BoughtEvent();
}

class AddNewBoughtEvent extends BoughtEvent {
  final Bought bought;

  const AddNewBoughtEvent({
    required this.bought
  });
}
class LoadedBought extends BoughtEvent {
  final String uId;
  LoadedBought({required this.uId});
}