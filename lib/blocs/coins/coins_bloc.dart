import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/coins_model.dart';
import '../../repository/coins/coins_repository.dart';
part 'coins_event.dart';

part 'coins_state.dart';
class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final CoinsRepository _coinsRepository;

  CoinsBloc(this._coinsRepository)
      : super(CoinsInitial()) {
    on<LoadedCoins>(_onLoadCoins);
    on<AddNewCoinsEvent>(_onAddNewCoins);
    on<EditCoinsEvent>(_onEditCoins);
  }

  void _onLoadCoins(event, Emitter<CoinsState> emit) async {
    try {
      Coins coins = await _coinsRepository.getCoinsById(event.uId);
      if(coins.quantity != null){
        emit(CoinsLoaded(coins: coins));
      }
      else{
        Coins newCoins = Coins(uId: event.uId, quantity: 0);
        await _coinsRepository.addCoins(newCoins);
        emit(AddCoins(coins: newCoins));
      }
    } catch (e) {
      emit(CoinsError(e.toString()));
    }
  }

  void _onAddNewCoins(event, Emitter<CoinsState> emit) async {
    final coins = Coins(
        quantity: event.quantity,
        uId: event.uId
    );
    emit(CoinsLoading());
    try {
      Coins? newCoins = await _coinsRepository.getCoinsById(event.uId);
      if(newCoins.coinsId == null){
        await _coinsRepository.addCoins(coins);
        emit(AddCoins(coins: coins));
      }
    } catch (e) {
      emit(const CoinsError('error'));
    }
  }

  void _onEditCoins(event, Emitter<CoinsState> emit) async {
    final coins = Coins(
      uId: event.uId,
      quantity: event.quantity,
      coinsId: event.coinsId
    );
    emit(CoinsLoading());
    try {
      await _coinsRepository.editCoins(coins);
      emit(AddCoins(coins: coins));
    } catch (e) {
      //print('error: ${e.toString()}');
      emit(CoinsError('error: $e'));
    }
  }
}