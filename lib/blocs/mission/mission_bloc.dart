import 'dart:async';
import 'package:e_book_app/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/mission/mission_repository.dart';

part 'mission_event.dart';

part 'mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final MissionRepository _missionRepository;
  StreamSubscription<List<Mission>>? _missionSubscription;

  MissionBloc(this._missionRepository) : super(MissionInitial()) {
    on<LoadedMissions>(_onLoadMissions);
    on<EditMissions>(_onEditMissions);
    on<LoadedMissionsByType>(_onLoadMissionsByType);
    on<UpdatedMission>(_onUpdatedMission);
  }

  void _onLoadMissions(event, Emitter<MissionState> emit) async {
    _missionSubscription?.cancel();
    _missionSubscription = _missionRepository.getAllMissions().listen(
          (missions) {
        add(UpdatedMission(missions: missions));
      },
      onError: (error) {
        emit(MissionError(error.toString()));
      },
    );
  }

  void _onUpdatedMission(UpdatedMission event, Emitter<MissionState> emit) {
    emit(MissionLoaded(missions: event.missions));
  }

  void _onEditMissions(event, Emitter<MissionState> emit) async {
    emit(MissionLoading());
    try {
      await _missionRepository.editMission(event.mission);
      emit(MissionLoaded(missions: [event.mission]));
    } catch (e) {
      //print(e.toString());
      emit(MissionError(e.toString()));
    }
  }

  void _onLoadMissionsByType(event, Emitter<MissionState> emit) async {
    try {
      List<Mission>? mission = await _missionRepository.getMissionByType(event.type);
      if(mission != null){
        emit(MissionLoadedByType(mission: mission));
      }
      else{
        emit(const MissionError(''));
      }
    } catch (e) {
      //print(e.toString());
      emit(MissionError(e.toString()));
    }
  }
  @override
  Future<void> close() {
    _missionSubscription?.cancel();
    return super.close();
  }
}
