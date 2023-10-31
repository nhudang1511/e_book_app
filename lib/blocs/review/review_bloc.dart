import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:equatable/equatable.dart';

import '../../model/review_model.dart';
part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;
  StreamSubscription? _reviewSubscription;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewLoading()){
    on<LoadedReview>(_onLoadReview);
    on<UpdateReview>(_onUpdateReview);
  }
  void _onLoadReview(event, Emitter<ReviewState> emit) async{
    _reviewSubscription?.cancel();
    _reviewSubscription =
        _reviewRepository
            .getAllReview()
            .listen((event) => add(UpdateReview(event)));
  }
  void _onUpdateReview(event, Emitter<ReviewState> emit) async{
    emit(ReviewLoaded(reviews: event.reviews));
  }
}
