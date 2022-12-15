import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/booking_repository.dart';
import 'package:atb_booking/data/services/users_provider.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_delete_confirmation_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/locked_plan_bloc/locked_plan_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'booking_details_event.dart';

part 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  static final BookingDetailsBloc _singleton = BookingDetailsBloc._internal();

  factory BookingDetailsBloc() {
    return _singleton;
  }
  bool deleteButtonIsActive = true;
  Booking? booking;

  // todo получаем айди из секьюрити
  BookingDetailsBloc._internal() : super(BookingDetailsInitialState()) {
    on<BookingDetailsLoadEvent>((event, emit) async {
      try {
        deleteButtonIsActive = event.deleteButtonIsActive;
        emit(BookingDetailsLoadingState());
        booking = await BookingRepository().getBookingById(event.bookingId);
        LockedPlanBloc().add(LockedPlanLoadEvent(booking!.levelId,booking!.workspace.id));
        emit(BookingDetailsLoadedState(booking!,event.deleteButtonIsActive));
      } catch (_) {
        emit(BookingDetailsErrorState());
      }
    });
    on<BookingDetailsDeleteEvent>((event, emit) async {
      try {
        BookingDeleteConfirmationBloc()
            .add(BookingDeleteConfirmationLoadEvent());
        await BookingRepository().deleteBooking(booking!.id);
        BookingListBloc().add(BookingListLoadEvent());
        BookingDeleteConfirmationBloc()
            .add(BookingDeleteConfirmationSuccessEvent());
        emit(BookingDetailsDeletedState(booking!));
      } catch (_) {
        BookingDeleteConfirmationBloc()
            .add(BookingDeleteConfirmationErrorEvent());
      }
    });
    on<BookingDetailsToFavoriteEvent>((event, emit) async {
        event.user.isFavorite = true;
        try{
          UsersProvider().addFavoritesProvider(event.user.id);
        }catch(_){
          event.user.isFavorite = false;
        }
        emit(BookingDetailsLoadedState(booking!,deleteButtonIsActive));
    });
    on<BookingDetailsRemoveFromFavoriteEvent>((event, emit) async {
      event.user.isFavorite = false;
      //todo send to server isFavorite
      try{
        await UsersProvider().deleteFromFavoritesProvider(event.user.id);
      }catch(_){
        event.user.isFavorite = true;
      }
      emit(BookingDetailsLoadedState(booking!,deleteButtonIsActive));
    });
  }

}
