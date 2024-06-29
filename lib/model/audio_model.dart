import 'package:e_book_app/model/custom_model.dart';
class Audio extends CustomModel{
  final String? id;
  final String? bookId;
  final Map<String,dynamic>? chapterList;
  Audio({this.id,this.bookId,this.chapterList});

  @override
  Audio fromJson(Map<String, dynamic> json) {
    Audio chapters = Audio(
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