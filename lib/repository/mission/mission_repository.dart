import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/config/shared_preferences.dart';
import '../../model/mission_model.dart';
import 'base_mission_repository.dart';

class MissionRepository extends BaseMissionRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  MissionRepository();

  @override
  Future<List<Mission>> getAllMission() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('mission').get();
      List<Mission> missions = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        var missionUser = await _firebaseFirestore
            .collection('mission_user')
            .where('uId', isEqualTo: SharedService.getUserId())
            .where('missionId', isEqualTo: data['id']).where('status', isEqualTo: false)
            .get();
        if (missionUser.size != 0) {
          data['status'] = false;
        } else {
          data['status'] = true;
        }
        missions.add(Mission().fromJson(data));
      }
      return missions;
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
  Future<List<Mission>>? getMissionByType(String type) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('mission')
          .where('type', isEqualTo: type)
          .get();
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
  Future<Mission?> getMissionById(String missionId) async {
    try {
      var documentSnapshot =
          await _firebaseFirestore.collection('mission').doc(missionId).get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        if (data != null) {
          data['id'] = documentSnapshot.id;
          return Mission().fromJson(data);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
