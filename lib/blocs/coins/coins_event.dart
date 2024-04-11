part of 'coins_bloc.dart';

abstract class CoinsEvent{
  const CoinsEvent();
}

class LoadedCoins extends CoinsEvent {
  final String uId;
  LoadedCoins({required this.uId});
}

class AddNewCoinsEvent extends CoinsEvent {
  final int quantity;
  final String uId;

  const AddNewCoinsEvent({
    required this.quantity,
    required this.uId,
  });
}
class EditCoinsEvent extends CoinsEvent {
  final int quantity;
  final String uId;
  final String coinsId;

  const EditCoinsEvent({
    required this.quantity,
    required this.uId,
    required this.coinsId
  });
}