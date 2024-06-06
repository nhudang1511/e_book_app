import 'package:e_book_app/model/models.dart';
import 'package:e_book_app/repository/coins/coins_repository.dart';
import 'package:e_book_app/repository/mission/mission_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/shared_preferences.dart';
import '../../repository/mission_user/mission_user_repository.dart';

part 'mission_user_event.dart';

part 'mission_user_state.dart';

class MissionUserBloc extends Bloc<MissionUserEvent, MissionUserState> {
  final MissionUserRepository _missionUserRepository;

  MissionUserBloc(this._missionUserRepository) : super(MissionUserInitial()) {
    on<AddMissionUsers>(_onAddMissionUsers);
    on<EditMissionUsers>(_onEditMissionUsers);
    on<LoadedMissionsUserById>(_onLoadedMissionUsersById);
    on<LoadedMissionUsers>(_onLoadedMissionUsers);
  }

  void _onLoadedMissionUsersById(event, Emitter<MissionUserState> emit) async {
    try {
      List<MissionUser?> missionUser = await _missionUserRepository
          .getMissionUsersByMissionId(event.missionId, event.uId);
      if (missionUser.isNotEmpty) {
        final missionRepository = MissionRepository();
        Mission? newMission =
            await missionRepository.getMissionById(event.missionId);
        int? time = newMission?.times;
        for (var m in missionUser) {
          if (m?.status == true && m!.times! < time!) {
            emit(MissionUserLoaded(mission: m));
          }
        }
      } else {
        MissionUser missionUser = MissionUser(
            status: true,
            missionId: event.missionId,
            times: 0,
            uId: SharedService.getUserId());
        await _missionUserRepository.addMissionUser(missionUser);
        MissionUser? newMission =
            await _missionUserRepository.getMissionUsersByMissionIdUId(
                missionUser.missionId ?? '', missionUser.uId ?? '');
        if(newMission != null){
          emit(MissionUserLoaded(mission: newMission ));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(MissionUserError(e.toString()));
    }
  }

  void _onAddMissionUsers(event, Emitter<MissionUserState> emit) async {
    emit(MissionUserLoading());
    try {
      await _missionUserRepository.addMissionUser(event.mission);
      emit(MissionUserLoaded(mission: event.mission));
    } catch (e) {
      emit(MissionUserError(e.toString()));
    }
  }

  void _onEditMissionUsers(event, Emitter<MissionUserState> emit) async {
    emit(MissionUserLoading());
    try {
      await _missionUserRepository.editMissionUser(event.mission);
      emit(MissionUserLoaded(mission: event.mission));
    } catch (e) {
      emit(MissionUserError(e.toString()));
    }
  }

  void _onLoadedMissionUsers(event, Emitter<MissionUserState> emit) async {
    try {
      List<MissionUser> missionUser =
          await _missionUserRepository.getAllMissionUser(event.uId);
      MissionRepository missionRepository = MissionRepository();
      CoinsRepository coinsRepository = CoinsRepository();
      Coins? coins =
          await coinsRepository.getCoinsById(SharedService.getUserId() ?? '');
      for (var m in missionUser) {
        Mission? mission =
            await missionRepository.getMissionById(m.missionId ?? '');
        if (m.times == mission?.times) {
          await _missionUserRepository.editMissionUser(MissionUser(
              id: m.id,
              status: false,
              missionId: m.missionId,
              times: m.times,
              uId: m.uId));
          await coinsRepository.editCoins(Coins(
              uId: m.uId,
              coinsId: coins.coinsId,
              quantity: coins.quantity! + mission!.coins!));
        }
      }
      if(missionUser.isNotEmpty){
        emit(MissionUserListLoaded(mission: missionUser));
      }
    } catch (e) {
      emit(MissionUserError(e.toString()));
    }
  }
}
