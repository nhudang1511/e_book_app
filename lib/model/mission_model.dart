import 'custom_model.dart';

class Mission extends CustomModel{

  final String? name;
  final String? detail;
  final String? type;
  final int? times;
  final int? coins;

  Mission({this.name, this.detail, this.type, this.times, this.coins});

  @override
  Mission fromJson(Map<String, dynamic> json) {
    Mission mission = Mission(
      name: json['name'],
      detail: json['detail'],
      type: json['type'],
      times: json['times'],
      coins: json['coins']
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
      'coins': coins
    };
  }
}