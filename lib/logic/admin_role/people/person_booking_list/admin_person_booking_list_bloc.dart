import 'dart:async';

import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/booking_api_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_person_booking_list_event.dart';
part 'admin_person_booking_list_state.dart';

class AdminPersonBookingListBloc
    extends Bloc<AdminPersonBookingListEvent, AdminPersonBookingListState> {
  final User user;
  List<Booking> bookingList = [];
  bool isGuest = false;
  bool isHolder = true;
  AdminPersonBookingListBloc(this.user)
      : super(AdminPersonBookingListLoadingState()) {
    on<AdminPersonBookingLoadBookingsEvent>((event, emit) async {
      emit(AdminPersonBookingListLoadingState());
      try {
        bookingList = await BookingProvider().getBookingsByUserId(user.id, isHolder: isHolder, isGuest: isGuest);
        emit(AdminPersonBookingListLoadedState(user, bookingList));
      } catch (_) {
        emit(AdminPersonBookingListErrorState());
      }
    });
    add(AdminPersonBookingLoadBookingsEvent());
  }
}
