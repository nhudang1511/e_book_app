import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_model.dart';

class Bought extends CustomModel {
  final String? id;
  final int? coin;
  final String? uId;
  final bool? status;
  final Timestamp? createdAt;
  final Timestamp? updateAt;
  final String? bookId;

  Bought(
      {this.id,
        this.coin,
        this.uId,
        this.status,
        this.createdAt,
        this.updateAt,
        this.bookId
      });

  @override
  Bought fromJson(Map<String, dynamic> json) {
    Bought coins = Bought(
        id: json['id'],
        coin: json['coin'],
        uId: json['uId'],
        status: json['status'],
        createdAt: json['createdAt'] as Timestamp?,
        updateAt: json['updateAt'] as Timestamp?,
      bookId: json['bookId']
    );
    return coins;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'uId': uId,
      'status': status,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'bookId': bookId
    };
  }
}
