import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/booking_repository.dart';
import 'package:atb_booking/data/services/users_provider.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/locked_plan_bloc/locked_plan_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'booking_details_event.dart';

part 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  bool deleteButtonIsActive = true;
  Booking? booking;
  User? holder;
  int? currentUserId;
  // todo получаем айди из секьюрити
  BookingDetailsBloc(int bookingId, this.deleteButtonIsActive) : super(BookingDetailsLoadingState()) {
    on<BookingDetailsLoadEvent>((event, emit) async {
      try {
        deleteButtonIsActive = deleteButtonIsActive;
        emit(BookingDetailsLoadingState());
        int currentUserId = await SecurityStorage().getIdStorage();
        booking = await BookingRepository().getBookingById(bookingId);
        holder = await UsersProvider().fetchUserById(booking!.holderId);
        LockedPlanBloc().add(LockedPlanLoadEvent(booking!.levelId,booking!.workspace.id));
        emit(BookingDetailsLoadedState(booking!,deleteButtonIsActive,holder!,currentUserId));
      } catch (_) {
        emit(BookingDetailsErrorState());
      }
    });
    on<BookingDetailsDeleteEvent>((event, emit) async {
      try {

        await BookingRepository().deleteBooking(booking!.id);
        BookingListBloc().add(BookingListLoadEvent());

        emit(BookingDetailsDeletedState(booking!));
      } catch (_) {
          print(_);
      }
    });
    on<BookingDetailsToFavoriteEvent>((event, emit) async {
        event.user.isFavorite = true;
        try{
          await UsersProvider().addFavorite(event.user.id);
        }catch(_){
          event.user.isFavorite = false;
        }
        emit(BookingDetailsLoadedState(booking!,deleteButtonIsActive,holder!,currentUserId!));
    });
    on<BookingDetailsRemoveFromFavoriteEvent>((event, emit) async {
      event.user.isFavorite = false;
      //todo send to server isFavorite
      try{
        await UsersProvider().deleteFromFavorites(event.user.id);
      }catch(_){
        event.user.isFavorite = true;
      }
      emit(BookingDetailsLoadedState(booking!,deleteButtonIsActive,holder!,currentUserId!));
    });
    add(BookingDetailsLoadEvent());
  }

}
