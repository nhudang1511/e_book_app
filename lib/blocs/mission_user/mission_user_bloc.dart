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
  }

  void _onLoadedMissionUsersById(event, Emitter<MissionUserState> emit) async {
    try {
      MissionRepository missionRepository = MissionRepository();
      List<Mission>? mission = await missionRepository.getMissionByType(event.type);
      if(mission != null){
       for(var m in mission){
         print(m.id);
         MissionUser? missionUser = await _missionUserRepository
             .getMissionUsersByMissionIdUId(m.id ?? '', SharedService.getUserId() ?? '');
         if (missionUser != null) {
           if (missionUser.status == true && missionUser.times! < m.times!) {
             emit(MissionUserLoaded(missionUser: missionUser, mission: m));
           }
         } else {
           MissionUser missionUser = MissionUser(
               status: true,
               missionId: m.id,
               times: 0,
               uId: SharedService.getUserId());
           await _missionUserRepository.addMissionUser(missionUser).then((value) async {
             MissionUser? missionUser = await _missionUserRepository
                 .getMissionUsersByMissionIdUId(m.id ?? '', SharedService.getUserId() ?? '');
             if (missionUser != null) {
               if (missionUser.status == true && missionUser.times! < m.times!) {
                 emit(MissionUserLoaded(missionUser: missionUser, mission: m));
               }
             }
           });
         }
       }

      }
    } catch (e) {
      // print(e.toString());
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
      await _missionUserRepository.editMissionUser(event.missionUser).then((value) async {
        print('2 ${event.missionUser.missionId}');
        CoinsRepository coinsRepository = CoinsRepository();
        Coins? coins = await coinsRepository.getCoinsById(SharedService.getUserId() ?? '');
        Mission? mission = event.mission;
        if(mission?.times == event.missionUser.times){
          await _missionUserRepository.editMissionUser(MissionUser(
              id: event.missionUser.id,
              status: false,
              missionId: event.missionUser.missionId,
              times: event.missionUser.times,
              uId: event.missionUser.uId));
          await coinsRepository.editCoins(Coins(
              uId: event.missionUser.uId,
              coinsId: coins.coinsId,
              quantity: coins.quantity! + mission!.coins!));
          emit(MissionUserFinish());
        }
        else{
          emit(const MissionUserError('error'));
        }
      });
    } catch (e) {
      emit(MissionUserError(e.toString()));
    }
  }
}
