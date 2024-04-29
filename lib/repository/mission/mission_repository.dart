import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

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
}