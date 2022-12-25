
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/office_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'admin_booking_stats_event.dart';

part 'admin_booking_stats_state.dart';

class AdminBookingStatsBloc
    extends Bloc<AdminBookingStatsEvent, AdminBookingStatsState> {
  DateTimeRange? _selectedDateTimeRange;
  final int officeId;

  AdminBookingStatsBloc(this.officeId)
      : super(const AdminBookingStatsInitial(null)) {
    on<AdminBookingStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AdminBookingStatsSelectNewRangeEvent>((event, emit) async {
      try {
        List<OfficeBookingStatsItem> stats = await OfficeProvider()
            .getStatsByRange(
            officeId, event.newRange.start, event.newRange.end);
        _selectedDateTimeRange = event.newRange;
        stats.forEach((element) {print(element.date);});
        emit(AdminBookingStatsLoadedState(_selectedDateTimeRange, stats));
        }catch(_)
        {
          print(_);
          emit(AdminBookingStatsErrorState(_selectedDateTimeRange));
        }
      });
  }
}
