import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_model.dart';

class Contact extends CustomModel {
  final String? id;
  final String? uId;
  final String? type;
  final bool? status;
  final Timestamp? createdAt;
  final Timestamp? updateAt;
  final String? content;

  Contact(
      {this.id,
      this.uId,
      this.type,
      this.status,
      this.createdAt,
      this.updateAt,
      this.content});

  @override
  Contact fromJson(Map<String, dynamic> json) {
    Contact coins = Contact(
        id: json['id'],
        uId: json['uId'],
        type: json['type'],
        status: json['status'],
        createdAt: json['createdAt'] as Timestamp?,
        updateAt: json['updateAt'] as Timestamp?,
        content: json['content']);
    return coins;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'type': type,
      'status': status,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'content': content
    };
  }
}
