import 'custom_model.dart';

class Mission extends CustomModel{

  final String? name;
  final String? detail;
  final String? type;
  final int? times;
  final int? coins;
  final String? id;

  Mission({this.name, this.detail, this.type, this.times, this.coins, this.id});

  @override
  Mission fromJson(Map<String, dynamic> json) {
    Mission mission = Mission(
      name: json['name'],
      detail: json['detail'],
      type: json['type'],
      times: json['times'],
      coins: json['coins'],
      id: json['id'],
    );
    return mission;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'detail': detail,
      'type': type,
      'times': times,
      'coins': coins,
    };
  }
}