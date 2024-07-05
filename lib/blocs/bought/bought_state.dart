part of 'bought_bloc.dart';
abstract class BoughtState {
  const BoughtState();
}
class BoughtInitial extends BoughtState {
}
class BoughtLoading extends BoughtState{
}
class AddBought extends BoughtState{
  final Bought bought;
  const AddBought({required this.bought});
}
class BoughtLoaded extends BoughtState{
  final Bought bought;
  const BoughtLoaded({required this.bought});
}
class BoughtError extends BoughtState {
  final String error;

  const BoughtError(this.error);
}