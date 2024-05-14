import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book_app/repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/review_model.dart';

part 'review_event.dart';

part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc(this._reviewRepository)
      :super(ReviewInitial()) {
    on<LoadedReview>(_onLoadReview);
    on<AddNewReviewEvent>(_onAddNewReview);
  }

  void _onLoadReview(event, Emitter<ReviewState> emit) async {
    try {
      List<Review> reviews = await _reviewRepository.getAllReview();
      emit(ReviewLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  void _onAddNewReview(event, Emitter<ReviewState> emit) async {
    final review = Review(
        bookId: event.bookId,
        content: event.content,
        status: event.status,
        userId: event.userId,
        time: event.time,
        rating: event.rating);
    emit(ReviewLoading());
    try {
      await _reviewRepository.addBookInHistory(review);
      emit(ReviewLoaded(reviews: [review]));
    } catch (e) {
      emit(const ReviewError('error'));
    }
  }
}
