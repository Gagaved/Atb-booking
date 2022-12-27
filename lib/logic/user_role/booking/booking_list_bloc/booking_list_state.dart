part of 'booking_list_bloc.dart';
abstract class BookingListState {
  final List<bool> filterList;

  BookingListState({required this.filterList});/*= <bool>[true, false, false];*/
}

class BookingListLoadingState extends BookingListState{
  BookingListLoadingState({required super.filterList});
}
class BookingListLoadedState extends BookingListState{
  List<Booking> bookingList;
  Map<int,WorkspaceType> mapOfTypes;
  BookingListLoadedState( {required super.filterList, required this.bookingList, required this.mapOfTypes});
}
class BookingListErrorState extends BookingListState{
  BookingListErrorState({required super.filterList});

}
