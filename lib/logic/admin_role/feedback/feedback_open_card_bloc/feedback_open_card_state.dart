part of 'feedback_open_card_bloc.dart';

@immutable
abstract class FeedbackOpenCardState {}

class FeedbackOpenCardLoadingState extends FeedbackOpenCardState {}

class FeedbackOpenCardLoadedState extends FeedbackOpenCardState {
  final FeedbackItem feedback;
  final User user;
  final User? complaint;

  FeedbackOpenCardLoadedState(this.feedback, this.user, this.complaint);
}

class FeedbackOpenCardErrorState extends FeedbackOpenCardState {}
