import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class History extends Equatable{
  final String uId;
  final String chapters;
  final double percent;
  const History({required this.uId, required this.chapters, required this.percent});
  @override
  List<Object?> get props => [uId,chapters,percent];
  Map<String, Object> toDocument(){
    return {
      'uId': uId,
      'chapters': chapters,
      'percent': percent
    };
  }
  static History fromSnapshot(DocumentSnapshot snap) {
    History history = History(
        uId: snap['uId'],
        chapters: snap['chapters'],
        percent: snap['percent']);
    return history;
  }

}