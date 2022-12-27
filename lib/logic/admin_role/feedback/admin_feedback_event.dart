part of 'admin_feedback_bloc.dart';

@immutable
abstract class AdminFeedbackEvent {}

class AdminFeedbackType_ApplicationMessageEvent extends AdminFeedbackEvent {}
class AdminFeedbackType_UserComplaintEvent extends AdminFeedbackEvent {}
class AdminFeedbackType_WorkplaceComplaintEvent extends AdminFeedbackEvent {}

class AdminFeedbackLoadEvent extends AdminFeedbackEvent {
  final bool formHasBeenChanged;
  AdminFeedbackLoadEvent(this.formHasBeenChanged);
}
class AdminFeedbackLoadNextPageEvent extends AdminFeedbackEvent {}

class AdminFeedbackDeleteItemEvent extends AdminFeedbackEvent {
  final FeedbackItem feedbackItem;
  AdminFeedbackDeleteItemEvent(this.feedbackItem);
}