import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/booking_api_provider.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meta/meta.dart';

part 'people_profile_booking_event.dart';
part 'people_profile_booking_state.dart';

class PeopleProfileBookingBloc
    extends Bloc<PeopleProfileBookingEvent, PeopleProfileBookingState> {
  static final PeopleProfileBookingBloc _singleton =
      PeopleProfileBookingBloc._internal();

  factory PeopleProfileBookingBloc() {
    return _singleton;
  }
  int? currentUserId;
  PeopleProfileBookingBloc._internal()
      : super(PeopleProfileBooking_LoadingState()) {
    on<PeopleProfileBookingLoadEvent>((event, emit) async {
      try {
        emit(PeopleProfileBooking_LoadingState());
        currentUserId = event.id;
        final List<Booking> bookingList =
            await BookingProvider().getBookingsByUserId(currentUserId!, isHolder: true,isGuest:false);
        final Map<int, WorkspaceType> mapOfTypes =
            await WorkspaceTypeRepository().getMapOfTypes();
        initializeDateFormatting();
        if (bookingList.isEmpty) {
          emit(PeopleProfileBooking_EmptyState());
        } else {
          emit(PeopleProfileBooking_LoadedState(
              bookingList: bookingList, mapOfTypes: mapOfTypes));
        }
      } catch (_) {
        emit(PeopleProfileBookingErrorState());
      }
    });
    on<PeopleProfileBookingCardTapEvent>((event, emit) async {
      try {
        bool deleteButtonIsActive = await SecurityStorage().getIdStorage()==currentUserId;
      } catch (_) {}
    });
  }
}
