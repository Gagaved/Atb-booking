part of 'new_office_page_bloc.dart';

@immutable
abstract class NewOfficePageState {
  final Future<List<City>> futureCityList;

  const NewOfficePageState(this.futureCityList);
}

class NewOfficePageInitialState extends NewOfficePageState {
  const NewOfficePageInitialState(super.futureCityList);
}

//class NewOfficePageLoading extends NewOfficePageState {}
class NewOfficePageLoadedState extends NewOfficePageState {
  final String address;
  final int bookingRange;
  final DateTimeRange workTimeRange;
  final bool buttonIsActive;
  const NewOfficePageLoadedState(super.futureCityList, this.address,
      this.bookingRange, this.workTimeRange, this.buttonIsActive);
}

class NewOfficePageSuccessfulCreatedState extends NewOfficePageLoadedState{
  final int officeId;
  const NewOfficePageSuccessfulCreatedState(super.futureCityList, super.address, super.bookingRange, super.workTimeRange, super.buttonIsActive, this.officeId);

}

class NewOfficePageErrorCreatedState extends NewOfficePageLoadedState{
  const NewOfficePageErrorCreatedState(super.futureCityList, super.address, super.bookingRange, super.workTimeRange, super.buttonIsActive);

}