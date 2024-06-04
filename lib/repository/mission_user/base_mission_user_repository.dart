import 'package:e_book_app/model/mission_user_model.dart';
abstract class BaseMissionUserRepository{
  Future<List<MissionUser>> getAllMissionUser(String uId);
  Future<void> addMissionUser(MissionUser mission);
  Future<void> editMissionUser(MissionUser mission);
  Future<List<MissionUser?>> getMissionUsersByMissionId(String missionId, String uId);
  Future<MissionUser?> getMissionUsersByMissionIdUId(String missionId, String uId);
}