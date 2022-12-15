part of 'admin_office_page_bloc.dart';

@immutable
abstract class AdminOfficePageEvent {}
class OfficePageLoadEvent extends AdminOfficePageEvent{
  final int officeId;

  OfficePageLoadEvent(this.officeId);
}
class AdminOfficeAddressChangeEvent extends AdminOfficePageEvent{
  final String address;

  AdminOfficeAddressChangeEvent(this.address);
}
class AdminBookingRangeChangeEvent extends AdminOfficePageEvent{
  final int bookingRange;

  AdminBookingRangeChangeEvent(this.bookingRange);
}
class AdminOfficePageUpdateFieldsEvent extends AdminOfficePageEvent{

}
class AdminOfficePageWorkRangeChangeEvent extends AdminOfficePageEvent{
  final DateTimeRange newWorkTimeRange;

  AdminOfficePageWorkRangeChangeEvent(this.newWorkTimeRange);
}