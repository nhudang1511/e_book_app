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
class LoadedBoughtFinish extends BoughtEvent {
  final String uId;
  LoadedBoughtFinish({required this.uId});
}
class LoadedBoughtByUId extends BoughtEvent{
  final String uId;
  LoadedBoughtByUId({required this.uId});
}
class LoadedBoughtByMonth extends BoughtEvent{
  final String uId;
  final DateTime month;
  LoadedBoughtByMonth({required this.uId, required this.month});
}