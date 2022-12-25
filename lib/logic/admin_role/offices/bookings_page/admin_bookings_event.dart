part of 'admin_bookings_bloc.dart';

@immutable
abstract class AdminBookingsEvent {}
class AdminBookingsSelectNewRangeEvent extends AdminBookingsEvent{
  final DateTimeRange newRange;

  AdminBookingsSelectNewRangeEvent(this.newRange);
}
class AdminBookingsLoadNextPageEvent extends AdminBookingsEvent {}
class AdminBookingsUpdateEvent extends AdminBookingsEvent{}