import 'package:e_book_app/model/mission_model.dart';

abstract class BaseMissionRepository{
  Future<List<Mission>> getAllMission();
  Future<void> editMission(Mission mission);
  Future<List<Mission>>? getMissionByType(String type);
  Future<Mission?> getMissionById(String missionId);
}