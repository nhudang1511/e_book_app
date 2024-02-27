part of 'chapters_bloc.dart';
abstract class ChaptersState{
 const ChaptersState();
}
class ChaptersLoading extends ChaptersState{
}
class ChaptersLoaded extends ChaptersState{
 final Chapters chapters;
 const ChaptersLoaded({required this.chapters});
}
class ChaptersFailure extends ChaptersState{

}