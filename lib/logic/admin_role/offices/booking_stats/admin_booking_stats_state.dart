part of 'admin_booking_stats_bloc.dart';

@immutable
abstract class AdminBookingStatsState {
  final DateTimeRange? selectedDateTimeRange;

  const AdminBookingStatsState(this.selectedDateTimeRange);
}

class AdminBookingStatsInitial extends AdminBookingStatsState {
  const AdminBookingStatsInitial(super.selectedDateTimeRange);
}
class AdminBookingStatsLoadingState extends AdminBookingStatsState{
  const AdminBookingStatsLoadingState(super.selectedDateTimeRange);
}
class AdminBookingStatsLoadedState extends AdminBookingStatsState{
  const AdminBookingStatsLoadedState(super.selectedDateTimeRange, this.stats);
  final List<OfficeBookingStatsItem> stats;
}
class AdminBookingStatsErrorState extends AdminBookingStatsState{
  const AdminBookingStatsErrorState(super.selectedDateTimeRange);
}