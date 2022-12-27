part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackEvent {}

class FeedbackTypeFormEvent extends FeedbackEvent {
  final String type;
  FeedbackTypeFormEvent(this.type);
}

class FeedbackCityFormEvent extends FeedbackEvent {
  final City city;
  FeedbackCityFormEvent(this.city);
}

class FeedbackOfficeFormEvent extends FeedbackEvent {
  final Office office;
  FeedbackOfficeFormEvent(this.office);
}

class FeedbackLevelFormEvent extends FeedbackEvent {
  final LevelListItem level;
  FeedbackLevelFormEvent(this.level);
}

class FeedbackWorkplaceTapEvent extends FeedbackEvent {
   int? workplaceId;
  FeedbackWorkplaceTapEvent(this.workplaceId);
}

class FeedbackMessageInputEvent extends FeedbackEvent {
  final String form;
  FeedbackMessageInputEvent(this.form);
}

class FeedbackButtonSubmitEvent extends FeedbackEvent {}
