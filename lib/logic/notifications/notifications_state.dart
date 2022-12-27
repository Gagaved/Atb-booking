part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState {
  final List<NotificationsModel> ListOfNotifications;
  NotificationsState(this.ListOfNotifications);
}

class NotificationsLoadingState extends NotificationsState {
  final bool formHasBeenChanged;
  NotificationsLoadingState(this.formHasBeenChanged, super.ListOfNotifications);
}

class NotificationsLoadedState extends NotificationsState {
  NotificationsLoadedState(super.ListOfNotifications);
}

class NotificationsErrorState extends NotificationsState {
  NotificationsErrorState(super.ListOfNotifications);
}
