part of 'mission_user_bloc.dart';

abstract class MissionUserState {
  const MissionUserState();
}
class MissionUserInitial extends MissionUserState {
}
class MissionUserLoading extends MissionUserState{
}
class MissionUserLoaded extends MissionUserState{
  final MissionUser mission;
  const MissionUserLoaded({required this.mission});
}
class MissionUserListLoaded extends MissionUserState{
  final List<MissionUser?> mission;
  const MissionUserListLoaded({required this.mission});
}
class MissionUserError extends MissionUserState {
  final String error;

  const MissionUserError(this.error);
}