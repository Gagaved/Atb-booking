part of 'new_office_page_bloc.dart';

@immutable
abstract class NewOfficePageEvent {}

class NewOfficeBookingRangeChangeEvent extends NewOfficePageEvent {
  final int newRange;

  NewOfficeBookingRangeChangeEvent(this.newRange);
}

class NewOfficePageUpdateFieldsEvent extends NewOfficePageEvent {}

class NewOfficePageAddressChangeEvent extends NewOfficePageEvent {
  final String newAddress;

  NewOfficePageAddressChangeEvent(this.newAddress);
}

class NewOfficePageWorkTimeRangeChangeEvent extends NewOfficePageEvent{
  final DateTimeRange newWorkTimeRange;
  NewOfficePageWorkTimeRangeChangeEvent(this.newWorkTimeRange);
}
class NewOfficePageCitySelectedEvent extends NewOfficePageEvent{
  final City selectedCity;

  NewOfficePageCitySelectedEvent(this.selectedCity);
}
class NewOfficePageButtonPressEvent extends NewOfficePageEvent{
  NewOfficePageButtonPressEvent();}