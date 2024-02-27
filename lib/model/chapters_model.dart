import 'package:e_book_app/model/custom_model.dart';
class Chapters extends CustomModel{
  final String? id;
  final String? bookId;
  final Map<String,dynamic>? chapterList;
  Chapters({this.id,this.bookId,this.chapterList});
  
  @override
  Chapters fromJson(Map<String, dynamic> json) {
    Chapters chapters = Chapters(
        id: json['id'],
        bookId: json['bookId'],
        chapterList: json['chapterList']);
    return chapters;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}