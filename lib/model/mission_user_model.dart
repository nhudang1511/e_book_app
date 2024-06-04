import 'custom_model.dart';

class MissionUser extends CustomModel{

  final String? uId;
  final String? missionId;
  final bool? status;
  final int? times;
  final String? id;

  MissionUser({this.uId, this.missionId, this.status, this.times, this.id});

  @override
  MissionUser fromJson(Map<String, dynamic> json) {
    MissionUser missionUserModel = MissionUser(
      uId: json['uId'],
      missionId: json['missionId'],
      status: json['status'],
      times: json['times'],
      id: json['id'],
    );
    return missionUserModel;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'missionId': missionId,
      'status': status,
      'times': times,
    };
  }
}