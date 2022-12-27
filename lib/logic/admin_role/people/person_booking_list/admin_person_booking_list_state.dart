part of 'admin_person_booking_list_bloc.dart';

@immutable
abstract class AdminPersonBookingListState {}

class AdminPersonBookingListLoadingState extends AdminPersonBookingListState {}
class AdminPersonBookingListLoadedState extends AdminPersonBookingListState{
  final List<Booking> bookingList;
  final User user;
  AdminPersonBookingListLoadedState( this.user,this.bookingList);
}
class AdminPersonBookingListErrorState extends AdminPersonBookingListState{}