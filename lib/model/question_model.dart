import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_model.dart';

class Question extends CustomModel {
  final String? id;
  final bool? status;
  final Timestamp? createdAt;
  final Timestamp? updateAt;
  final String? title;
  final Map<String, dynamic>? questions;

  Question(
      {this.id,
      this.status,
      this.createdAt,
      this.updateAt,
      this.title,
      this.questions,});

  @override
  Question fromJson(Map<String, dynamic> json) {
    Question coins = Question(
        id: json['id'],
        status: json['status'],
        createdAt: json['createdAt'] as Timestamp?,
        updateAt: json['updateAt'] as Timestamp?,
        title: json['title'],
        questions: json['questions']);
    return coins;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'title': title,
      'questions': questions,
    };
  }
}
