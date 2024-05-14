import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/shared_preferences.dart';
import '../../model/mission_model.dart';
import 'base_mission_repository.dart';

class MissionRepository extends BaseMissionRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  MissionRepository();

  @override
  Future<List<Mission>> getAllMission() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('mission').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Mission().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> editMission(Mission mission) {
    return _firebaseFirestore
        .collection('mission')
        .doc(mission.id)
        .update(mission.toJson());
  }

  @override
  Future<Mission> getMissionByType(String type) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('mission')
          .orderBy("times", descending: false)
          .where('type', isEqualTo: type)
          .get();
      for (var doc in querySnapshot.docs) {
        var missionData = doc.data();
        missionData['id'] = doc.id;

        Mission mission = Mission().fromJson(missionData);
        // Check if the mission's users map is not empty and contains the current userId
        if (mission.users != null &&
            mission.users!.containsKey(SharedService.getUserId())) {
          if (mission.users![SharedService.getUserId()] < mission.times ||
              mission.users![SharedService.getUserId()] >= 0) {
            return mission;
          }
        } else {
          return mission;
        }
      }

      return Mission(); // Trả về mission mặc định nếu không tìm thấy mission thỏa mãn điều kiện
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Mission>> getMissionsFinish() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('mission').get();
      List<Mission> missions = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        Mission mission = Mission().fromJson(data);
        if (mission.users != null && mission.users!.containsKey(SharedService.getUserId())) {
          if (mission.users![SharedService.getUserId()] == mission.times) {
            missions.add(mission);
          }
        }
      }
      return missions;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
