import 'custom_model.dart';

class Category extends CustomModel{

  final String? id;
  final String? name;
  final bool? status;
  final String? imageUrl;

  Category({this.id, this.name, this.status, this.imageUrl});
  
  @override
  Category fromJson(Map<String, dynamic> json) {
    Category category = Category(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      imageUrl: json['imageUrl']
    );
    return category;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}