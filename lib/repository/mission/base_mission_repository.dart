import 'package:e_book_app/model/mission_model.dart';

abstract class BaseMissionRepository{
  Future<List<Mission>> getAllMission();
}