part of 'admin_feedback_bloc.dart';

@immutable
abstract class AdminFeedbackState {
  final int typeId;
  final List<String> listType;
  final List<FeedbackItem> feedbackListItems;
  AdminFeedbackState(this.typeId, this.listType, this.feedbackListItems);
}

class AdminFeedbackMainState extends AdminFeedbackState {
  AdminFeedbackMainState(super.typeId, super.listType, super.feedbackListItems);
}

class AdminFeedbackLoadingState extends AdminFeedbackState {
  final bool formHasBeenChanged;
  AdminFeedbackLoadingState(super.typeId, super.listType,
      super.feedbackListItems, this.formHasBeenChanged);
}

class AdminFeedbackErrorState extends AdminFeedbackState {
  AdminFeedbackErrorState(
      super.typeId, super.listType, super.feedbackListItems);
}
