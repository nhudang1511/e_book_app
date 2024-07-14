part of 'mission_user_bloc.dart';

abstract class MissionUserState {
  const MissionUserState();
}
class MissionUserInitial extends MissionUserState {
}
class MissionUserLoading extends MissionUserState{
}
class MissionUserLoaded extends MissionUserState{
  final MissionUser? missionUser;
  final Mission? mission;
  const MissionUserLoaded({this.missionUser, this.mission});
}
class MissionUserFinish extends MissionUserState{}
class MissionUserError extends MissionUserState {
  final String error;

  const MissionUserError(this.error);
}