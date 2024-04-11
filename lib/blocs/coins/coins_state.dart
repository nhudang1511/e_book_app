part of 'coins_bloc.dart';
abstract class CoinsState {
  const CoinsState();
}
class CoinsInitial extends CoinsState {
}
class CoinsLoading extends CoinsState{
}
class CoinsLoaded extends CoinsState{
  final Coins coins;
  const CoinsLoaded({required this.coins});
}
class AddCoins extends CoinsState{
  final Coins coins;
  const AddCoins({required this.coins});
}

class CoinsError extends CoinsState {
  final String error;

  const CoinsError(this.error);
}