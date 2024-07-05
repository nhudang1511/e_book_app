import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';

part 'bought_event.dart';

part 'bought_state.dart';

class BoughtBloc extends Bloc<BoughtEvent, BoughtState> {
  final BoughtRepository _boughtRepository;

  BoughtBloc(this._boughtRepository) : super(BoughtInitial()) {
    on<AddNewBoughtEvent>(_onAddNewBought);
    on<LoadedBought>(_onLoadedBought);
  }

  void _onAddNewBought(event, Emitter<BoughtState> emit) async {
    emit(BoughtLoading());
    try {
      await _boughtRepository.addBought(event.bought);
      emit(AddBought(bought: event.bought));
    } catch (e) {
      emit(const BoughtError('error'));
    }
  }

  void _onLoadedBought(event, Emitter<BoughtState> emit) async {
    try {
      Bought? bought = await _boughtRepository.getBoughtById(event.uId);
      CoinsRepository coinsRepository = CoinsRepository();
      Coins? coins = await coinsRepository.getCoinsById(event.uId);
      if (bought != null) {
        await _boughtRepository.editBought(Bought(
            status: false,
            uId: bought.uId,
            coin: bought.coin,
            id: bought.id,
            createdAt: bought.createdAt,
            updateAt: Timestamp.fromDate(DateTime.now())));
        await coinsRepository.editCoins(Coins(
            uId: event.uId,
            coinsId: coins.coinsId,
            quantity: coins.quantity! - bought.coin!));
        emit(BoughtLoaded(bought: bought));
      }
    } catch (e) {
      emit(BoughtError(e.toString()));
    }
  }
}
