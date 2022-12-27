part of 'complaint_bloc.dart';

@immutable
abstract class ComplaintEvent {}

class ComplaintStartingEvent extends ComplaintEvent {
  User user;
  ComplaintStartingEvent(this.user);
}

class ComplaintMessageInputEvent extends ComplaintEvent {
  final String form;
  ComplaintMessageInputEvent(this.form);
}

class ComplaintSubmitEvent extends ComplaintEvent {
  int userId;
  ComplaintSubmitEvent(this.userId);
}
