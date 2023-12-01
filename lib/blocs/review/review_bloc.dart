import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        super(ReviewInitial()) {
    on<LoadedReview>(_onLoadReview);
    on<UpdateReview>(_onUpdateReview);
    on<AddNewReviewEvent>(_onAddNewReview);
  }

  void _onLoadReview(event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    _reviewSubscription?.cancel();
    _reviewSubscription = _reviewRepository
        .getAllReview()
        .listen((event) => add(UpdateReview(event)));
  }

  void _onUpdateReview(event, Emitter<ReviewState> emit) async {
    emit(ReviewLoaded(reviews: event.reviews));
  }

  void _onAddNewReview(event, Emitter<ReviewState> emit) async {
    final review = Review(
        bookId: event.bookId,
        content: event.content,
        status: event.status,
        userId: event.userId,
        time: event.time);
    _reviewSubscription?.cancel();
    emit(ReviewLoading());
    try {
      await _reviewRepository.addBookInHistory(review);
      emit(ReviewLoaded(reviews: event.reviews));
    } catch (e) {
      emit(const ReviewError('error'));
    }
  }
}
