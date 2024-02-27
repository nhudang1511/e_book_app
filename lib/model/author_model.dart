import 'package:e_book_app/model/custom_model.dart';

class Author extends CustomModel{

  final String? id;
  final String? fullName;

  Author({this.id, this.fullName});

  @override
  Author fromJson(Map<String, dynamic> json) {
    Author author = Author(id: json['id'], fullName: json['fullName']);
    return author;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}