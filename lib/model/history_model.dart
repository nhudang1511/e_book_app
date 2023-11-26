import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class History extends Equatable{
  final String uId;
  final String chapters;
  final double percent;
  final int times;
  const History({required this.uId, required this.chapters, required this.percent, required this.times});
  @override
  List<Object?> get props => [uId,chapters,percent, times];
  Map<String, Object> toDocument(){
    return {
      'uId': uId,
      'chapters': chapters,
      'percent': percent,
      'times': times
    };
  }
  static History fromSnapshot(DocumentSnapshot snap) {
    History history = History(
        uId: snap['uId'],
        chapters: snap['chapters'],
        percent: snap['percent'],
      times: snap['times']
    );
    return history;
  }

}