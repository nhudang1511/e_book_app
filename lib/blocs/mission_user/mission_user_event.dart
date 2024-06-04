part of 'mission_user_bloc.dart';

abstract class MissionUserEvent{
  const MissionUserEvent();
}
class LoadedMissionUsers extends MissionUserEvent {
  final String uId;
  LoadedMissionUsers({required this.uId});
}
class AddMissionUsers extends MissionUserEvent {
  final MissionUser mission;

  const AddMissionUsers({
    required this.mission
  });
}
class EditMissionUsers extends MissionUserEvent {
  final MissionUser mission;

  const EditMissionUsers({
    required this.mission
  });
}
class LoadedMissionsUserById extends MissionUserEvent{
  final String missionId;
  final String uId;
  LoadedMissionsUserById({required this.missionId, required this.uId});
}