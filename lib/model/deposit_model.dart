import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_model.dart';

class Deposit extends CustomModel{

  final String? id;
  final int? coin;
  final int? money;
  final String? uId;
  final String? type;
  final bool? status;
  final Timestamp? createdAt;
  final Timestamp? updateAt;

  Deposit({this.id, this.coin, this.money, this.uId, this.type, this.status, this.createdAt, this.updateAt});

  @override
  Deposit fromJson(Map<String, dynamic> json) {
    Deposit coins = Deposit(
      id: json['id'],
      coin: json['coin'],
      money: json['money'],
      uId: json['uId'],
      type: json['type'],
      status: json['status'],
      createdAt: json['createdAt'] as Timestamp?,
      updateAt: json['updateAt'] as Timestamp?
    );
    return coins;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'coin': coin,
      'uId': uId,
      'type': type,
      'status' : status,
      'createdAt': createdAt,
      'updateAt': updateAt
    };
  }
}