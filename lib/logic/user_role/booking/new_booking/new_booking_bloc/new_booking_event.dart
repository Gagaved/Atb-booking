part of 'new_booking_bloc.dart';

abstract class NewBookingEvent {}

class NewBookingInitialEvent extends NewBookingEvent {}

class NewBookingCityFormEvent extends NewBookingEvent {
  final City city;

  NewBookingCityFormEvent(this.city);
}
// class NewBookingReloadCitiesEvent extends NewBookingEvent{
// }
class NewBookingOfficeFormEvent extends NewBookingEvent {
  final Office office;

  NewBookingOfficeFormEvent(this.office);
}

class NewBookingLevelFormEvent extends NewBookingEvent {
  final LevelListItem level;

  NewBookingLevelFormEvent(this.level);
}

class NewBookingButtonTimeEvent extends NewBookingEvent {}

class NewBookingBookEvent extends NewBookingEvent {}
