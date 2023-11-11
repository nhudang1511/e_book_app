part of 'chapters_bloc.dart';
abstract class ChaptersState extends Equatable{
 const ChaptersState();

 @override
 List<Object?> get props => [];
}
class ChaptersLoading extends ChaptersState{
 @override
 List<Object?> get props => [];
}
class ChaptersLoaded extends ChaptersState{
 final Chapters chapters;
 const ChaptersLoaded({required this.chapters});
 @override
 List<Object?> get props => [chapters];
}