part of 'mission_user_bloc.dart';

abstract class MissionUserEvent{
  const MissionUserEvent();
}
class AddMissionUsers extends MissionUserEvent {
  final MissionUser mission;

  const AddMissionUsers({
    required this.mission
  });
}
class EditMissionUsers extends MissionUserEvent {
  final MissionUser missionUser;
  final Mission? mission;

  const EditMissionUsers({
    required this.missionUser, this.mission
  });
}
class LoadedMissionsUserById extends MissionUserEvent{
  final String type;
  LoadedMissionsUserById({required this.type});
}