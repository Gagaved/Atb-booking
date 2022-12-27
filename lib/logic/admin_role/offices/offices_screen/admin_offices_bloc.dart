import 'dart:async';

import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/city_repository.dart';
import 'package:atb_booking/data/services/office_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_offices_event.dart';

part 'admin_offices_state.dart';

class AdminOfficesBloc extends Bloc<AdminOfficesEvent, AdminOfficesState> {
  City? selectedCity;
  Future<List<City>> futureCityList = CityRepository().getAllCities();

  AdminOfficesBloc()
      : super(AdminOfficesInitial(CityRepository().getAllCities())) {
    on<AdminOfficesCitySelectedEvent>((event, emit) async {
      selectedCity = event.city;
      emit(AdminOfficesLoadingState(futureCityList));
      try {
        futureCityList = CityRepository().getAllCities();
        List<Office> offices =
            await OfficeRepository().getOfficesByCityId(selectedCity!.id);
        emit(AdminOfficesLoadedState(futureCityList, offices));
      } catch (_) {
        print(_);
        futureCityList = CityRepository().getAllCities();
        emit(AdminOfficesErrorState(futureCityList));
      }
    });
    on<AdminOfficesReloadEvent>((event, emit) async {
      if (selectedCity != null) {
        try {
          futureCityList = CityRepository().getAllCities();
          List<Office> offices =
              await OfficeRepository().getOfficesByCityId(selectedCity!.id);
          emit(AdminOfficesLoadedState(futureCityList, offices));
        } catch (_) {
          print(_);
          futureCityList = CityRepository().getAllCities();
          emit(AdminOfficesErrorState(futureCityList));
        }
      }
    });
  }
}
