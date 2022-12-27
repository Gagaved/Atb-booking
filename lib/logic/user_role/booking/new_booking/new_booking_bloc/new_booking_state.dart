part of 'new_booking_bloc.dart';

@immutable
class NewBookingState {
  const NewBookingState();
}

/// Выбор города
class NewBookingFirstState extends NewBookingState {
  final Future<List<City>> futureCityList;
  final String labelCity;
  const NewBookingFirstState(this.futureCityList, this.labelCity);
}


/// Выбор офиса
class NewBookingSecondState extends NewBookingFirstState {
  final Future<List<Office>> futureOfficeList;
  final String labelOffice;
  const NewBookingSecondState(super.futureCityList, super.labelCity,this.futureOfficeList, this.labelOffice);
}

/// Выбор этажа
class NewBookingThirdState extends NewBookingSecondState {
  final Future<List<LevelListItem>> Function(String?) getFutureLevelList;
  final LevelListItem? selectedLevel;
  const NewBookingThirdState(super.futureCityList,super.labelCity,super.futureOfficeList,super.labelOffice,this.getFutureLevelList, this.selectedLevel);
}
///Выбор места и даты
class NewBookingFourthState extends NewBookingThirdState {
  const NewBookingFourthState(super.futureCityList,super.labelCity,super.futureOfficeList,super.labelOffice,super.getFutureLevelList, super.labelLevel);
}

///Отображение bottomSheet выбор интервала времени
class NewBookingFifthState extends NewBookingFourthState {
  const NewBookingFifthState(super.futureCityList,super.labelCity,super.futureOfficeList,super.labelOffice,super.getFutureLevelList, super.labelLevel);
}