part of 'mission_bloc.dart';
abstract class MissionState {
  const MissionState();
}
class MissionInitial extends MissionState {
}
class MissionLoading extends MissionState{
}
class MissionLoaded extends MissionState{
  final List<Mission> missions;
  const MissionLoaded({this.missions = const <Mission>[]});
}
class MissionLoadedByType extends MissionState{
  final List<Mission> mission;
  const MissionLoadedByType({required this.mission});
}
class MissionLoadedByFinish extends MissionState{
  final List<Mission> missions;
  const MissionLoadedByFinish({this.missions = const <Mission>[]});
}
class MissionError extends MissionState {
  final String error;

  const MissionError(this.error);
}