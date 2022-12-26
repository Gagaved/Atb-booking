import 'dart:async';

import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_repository.dart';
import 'package:atb_booking/data/services/office_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'new_office_page_event.dart';

part 'new_office_page_state.dart';

class NewOfficePageBloc extends Bloc<NewOfficePageEvent, NewOfficePageState> {
  City? selectedCity;
  Future<List<City>> futureCityList = CityRepository().getAllCities();
  String address = "";
  int bookingRange = 60;

  bool buttonIsActive() {
    return (address != "" &&
        bookingRange != 0 &&
        workTimeRange.start != workTimeRange.end);
  }

  DateTimeRange workTimeRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 10).toLocal(),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 20).toLocal());

  NewOfficePageBloc()
      : super(NewOfficePageInitialState(CityRepository().getAllCities())) {

    on<NewOfficePageWorkTimeRangeChangeEvent>((event, emit) {
      workTimeRange = event.newWorkTimeRange;
      emit(NewOfficePageLoadedState(futureCityList, address, bookingRange,
          workTimeRange, buttonIsActive()));
    });

    ///
    ///
    ///
    on<NewOfficePageButtonPressEvent>((event, emit) async {
      try {
        var office = Office(
          id: -1,
          address: address,
          maxBookingRangeInDays: bookingRange,
          workTimeRange: workTimeRange,
          cityId: selectedCity!.id,
        );
        int createdOfficeId = await OfficeProvider().createOffice(office);
        emit(NewOfficePageSuccessfulCreatedState(futureCityList, address,
            bookingRange, workTimeRange, buttonIsActive(), createdOfficeId));
      } catch (_) {
        emit(NewOfficePageErrorCreatedState(futureCityList, address,
            bookingRange, workTimeRange, buttonIsActive()));
      }
    });

    ///
    ///
    ///
    on<NewOfficePageCitySelectedEvent>((event, emit) {
      selectedCity = event.selectedCity;
      emit(NewOfficePageLoadedState(futureCityList, address, bookingRange,
          workTimeRange, buttonIsActive()));
    });
    on<NewOfficePageUpdateFieldsEvent>((event, emit) {
      emit(NewOfficePageLoadedState(futureCityList, address, bookingRange,
          workTimeRange, buttonIsActive()));
    });
    on<NewOfficeBookingRangeChangeEvent>((event, emit) {
      bookingRange = event.newRange;
      //emit(NewOfficePageLoadedState(futureCityList, address, bookingRange,workTimeRange, buttonIsActive()));
    });
    on<NewOfficePageAddressChangeEvent>((event, emit) {
      address = event.newAddress;
      emit(NewOfficePageLoadedState(futureCityList, address, bookingRange,
          workTimeRange, buttonIsActive()));
    });
  }
}
