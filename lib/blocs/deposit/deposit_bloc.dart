import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';

part 'deposit_event.dart';

part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final DepositRepository _depositRepository;

  DepositBloc(this._depositRepository) : super(DepositInitial()) {
    on<AddNewDepositEvent>(_onAddNewDeposit);
    on<LoadedDeposit>(_onLoadedDeposit);
    on<LoadedDepositByUId>(_onLoadedDepositByUId);
    on<LoadedDepositByMonth>(_onLoadedDepositByMonth);
  }

  void _onAddNewDeposit(event, Emitter<DepositState> emit) async {
    emit(DepositLoading());
    try {
      await _depositRepository.addDeposit(event.deposit);
      emit(AddDeposit(deposit: event.deposit));
    } catch (e) {
      emit(const DepositError('error'));
    }
  }

  void _onLoadedDeposit(event, Emitter<DepositState> emit) async {
    try {
      Deposit? deposit = await _depositRepository.getDepositById(event.uId);
      CoinsRepository coinsRepository = CoinsRepository();
      Coins? coins = await coinsRepository.getCoinsById(event.uId);
      if (deposit != null) {
        await _depositRepository.editDeposit(Deposit(
            status: false,
            type: deposit.type,
            uId: deposit.uId,
            money: deposit.money,
            coin: deposit.coin,
            id: deposit.id,
            createdAt: deposit.createdAt,
            updateAt: Timestamp.fromDate(DateTime.now())));
        await coinsRepository.editCoins(Coins(
            uId: event.uId,
            coinsId: coins.coinsId,
            quantity: coins.quantity! + deposit.coin!));
        emit(DepositLoaded(deposit: deposit));
      }
    } catch (e) {
      emit(DepositError(e.toString()));
    }
  }

  void _onLoadedDepositByUId(event, Emitter<DepositState> emit) async {
    emit(DepositLoading());
    try {
      num depositCoin = await _depositRepository.getTotalDeposits(event.uId);
      if (depositCoin != 0) {
        emit(DepositCoinLoaded(depositCoin: depositCoin));
      } else {
        emit(const DepositError('error'));
      }
    } catch (e) {
      emit(const DepositError('error'));
    }
  }

  void _onLoadedDepositByMonth(event, Emitter<DepositState> emit) async {
    emit(DepositLoading());
    try {
      num depositCoin = await _depositRepository.getTotalDepositsByMonth(
          event.uId, event.month);
      if (depositCoin != 0) {
        emit(DepositCoinLoaded(depositCoin: depositCoin));
      } else {
        emit(const DepositError('error'));
      }
    } catch (e) {
      emit(const DepositError('error'));
    }
  }
}
