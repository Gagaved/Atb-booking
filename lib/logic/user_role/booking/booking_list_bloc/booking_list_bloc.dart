import 'package:atb_booking/data/services/booking_api_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/booking.dart';
import '../../../../data/models/workspace_type.dart';
import '../../../../data/services/workspace_type_repository.dart';
import '../../../../logic/secure_storage_api.dart';

part 'booking_list_event.dart';

part 'booking_list_state.dart';

class BookingListBloc extends Bloc<BookingListEvent, BookingListState> {
  static final BookingListBloc _singleton = BookingListBloc._internal();

  factory BookingListBloc() {
    return _singleton;
  }

  bool isHolder = true;
  bool isGuest = false;
  List<bool> filter = <bool>[true, false, false];

  // todo получаем айди из секьюрити
  BookingListBloc._internal()
      : super(BookingListLoadingState(
          filterList: [true, false, false],
        )) {
    on<BookingListInitialEvent>((event, emit) async {
      emit(BookingListLoadingState(
        filterList: filter,
      ));
    });
    on<BookingListLoadEvent>((event, emit) async {
      try {
        final currentUserId = await SecurityStorage().getIdStorage();
        final List<Booking> bookingList = await BookingProvider()
            .getBookingsByUserId(currentUserId,
                isHolder: isHolder, isGuest: isGuest);
        final Map<int, WorkspaceType> mapOfTypes =
            await WorkspaceTypeRepository().getMapOfTypes();
        emit(BookingListLoadedState(
          filterList: filter,
          bookingList: bookingList,
          mapOfTypes: mapOfTypes,
        ));
      } catch (_) {
        emit(BookingListErrorState(
          filterList: filter,
        ));
      }
    });
    on<BookingCardTapEvent>((event, emit) async {
      try {} catch (_) {}
    });
    on<BookingListFilterChangeEvent>((event, emit) async {
      filter = [false, false, false]..[event.filterNewValue] = true;
      if (filter[0]) {
        isHolder = true;
        isGuest = false;
      } else if (filter[1]) {
        isHolder = false;
        isGuest = true;
      } else if (filter[2]) {
        isHolder = true;
        isGuest = true;
      }
      try {
        emit(BookingListLoadingState(
          filterList: filter,
        ));

        final currentUserId = await SecurityStorage().getIdStorage();
        final List<Booking> bookingList = await BookingProvider()
            .getBookingsByUserId(currentUserId,
                isHolder: isHolder, isGuest: isGuest);
        final Map<int, WorkspaceType> mapOfTypes =
            await WorkspaceTypeRepository().getMapOfTypes();
        emit(BookingListLoadedState(
          filterList: filter,
          bookingList: bookingList,
          mapOfTypes: mapOfTypes,
        ));
      } catch (_) {}
      add(BookingListLoadEvent());
    });
    add(BookingListLoadEvent());
  }
}
