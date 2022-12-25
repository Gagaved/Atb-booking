part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsEvent {}

class NotificationsLoadEvent extends NotificationsEvent {
  final bool formHasBeenChanged;
  NotificationsLoadEvent(this.formHasBeenChanged);
}

class NotificationsDeleteEvent extends NotificationsEvent {
  final NotificationsModel notification;
  NotificationsDeleteEvent(this.notification);
}

class NotificationsLoadNextPageEvent extends NotificationsEvent {}
