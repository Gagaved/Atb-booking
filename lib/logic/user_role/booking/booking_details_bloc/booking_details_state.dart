part of 'booking_details_bloc.dart';

abstract class BookingDetailsState {}

class BookingDetailsInitialState extends BookingDetailsState {}

class BookingDetailsLoadingState extends BookingDetailsState {}

class BookingDetailsLoadedState extends BookingDetailsState {
  final Booking booking;
  bool buttonIsShow = true;
  final User holderUser;
  int currentUserId;
  BookingDetailsLoadedState(this.booking,this.buttonIsShow,this.holderUser,this.currentUserId);
}
class BookingDetailsDeletedState extends BookingDetailsState {
  final Booking booking;

  BookingDetailsDeletedState(this.booking);
}

class BookingDetailsErrorState extends BookingDetailsState {}
