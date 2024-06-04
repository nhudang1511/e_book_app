import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/model/mission_user_model.dart';

import 'base_mission_user_repository.dart';

class MissionUserRepository extends BaseMissionUserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> editMissionUser(MissionUser mission) {
    return _firebaseFirestore
        .collection('mission_user')
        .doc(mission.id)
        .update(mission.toJson());
  }

  @override
  Future<List<MissionUser>> getAllMissionUser(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('mission_user')
          .where('uId', isEqualTo: uId)
          .orderBy("times", descending: false)
          .where('status', isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return MissionUser().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<MissionUser?>> getMissionUsersByMissionId(
      String missionId, String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('mission_user')
          .where('missionId', isEqualTo: missionId)
          .where('uId', isEqualTo: uId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return MissionUser().fromJson(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addMissionUser(MissionUser mission) {
    return _firebaseFirestore.collection('mission_user').add(mission.toJson());
  }

  @override
  Future<MissionUser?> getMissionUsersByMissionIdUId(String missionId, String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('mission_user')
          .where('missionId', isEqualTo: missionId)
          .where('uId', isEqualTo: uId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['id'] = querySnapshot.docs.first.id;
        return MissionUser().fromJson(data);
      }
      else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
