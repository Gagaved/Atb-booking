import 'package:atb_booking/data/models/notificathions.dart';
import 'package:atb_booking/data/services/notificationsProvider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  int page = 0;
  final int size = 10;
  bool formHasBeenChanged = true;
  List<NotificationsModel> notificathionsListItems = [];

  NotificationsBloc() : super(NotificationsLoadedState([])) {
    on<NotificationsLoadNextPageEvent>((event, emit) {
      formHasBeenChanged = false;
      page++;
      add(NotificationsLoadEvent(formHasBeenChanged));
    });
    on<NotificationsDeleteEvent>((event, emit) async {
      notificathionsListItems.remove(event.notification);
      try {
        await NotificationsProvider().deleteNotification(event.notification.id);
        emit(NotificationsLoadedState(notificathionsListItems));
      } catch (e) {
        emit(NotificationsErrorState(notificathionsListItems));
        print("Error delete notifications in bloc: $e");
      }
    });
    on<NotificationsLoadEvent>((event, emit) async {
      emit(NotificationsLoadingState(
          event.formHasBeenChanged, notificathionsListItems));
      if (event.formHasBeenChanged) page = 0;
      if (page == 0) {
        notificathionsListItems = [];
      }

      try {
        var newLoadNotifications =
            await NotificationsProvider().getNotifications(page, size);
        notificathionsListItems.addAll(newLoadNotifications);
      } catch (e) {
        emit(NotificationsErrorState(notificathionsListItems));
        print("Error into NotificationsLoadEvent: ${e.toString()}");
        throw (e);
      }
      emit(NotificationsLoadedState(notificathionsListItems));
    });
    add(NotificationsLoadEvent(true));
  }
}
