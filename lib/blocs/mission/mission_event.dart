part of 'mission_bloc.dart';

abstract class MissionEvent{
  const MissionEvent();
}

class LoadedMissions extends MissionEvent {
  LoadedMissions();
}
class LoadedMissionsByType extends MissionEvent{
  final String type;
  LoadedMissionsByType({required this.type});
}
class EditMissions extends MissionEvent {
  final Mission mission;

  const EditMissions({
    required this.mission
  });
}
class LoadedMissionsByFinish extends MissionEvent{
  LoadedMissionsByFinish();
}