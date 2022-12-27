import 'dart:async';
import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/booking_repository.dart';
import 'package:atb_booking/data/services/city_repository.dart';
import 'package:atb_booking/data/services/office_repository.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/plan_bloc/plan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_booking_sheet_bloc/new_booking_confirmation_popup_bloc.dart';
import 'new_booking_sheet_bloc/new_booking_sheet_bloc.dart';

part 'new_booking_event.dart';

part 'new_booking_state.dart';

class NewBookingBloc extends Bloc<NewBookingEvent, NewBookingState> {
  static final NewBookingBloc _singleton = NewBookingBloc._internal();

  factory NewBookingBloc() {
    return _singleton;
  }

  List<User> guests = [];
  int? selectedWorkspaceId;
  DateTime? selectedDate;
  Office? selectedOffice;
  City? selectedCity;
  LevelListItem? selectedLevel;
  DateTimeRange? selectedDateTimeRange;
  Future<List<Office>>? futureOfficeListItem;
  Future<List<LevelListItem>>? futureLevelList;
  Future<List<City>>? futureCityList;

  void setGuests(List<User> userList) {
    guests = [];
    guests.addAll(userList);
  }

  Future<List<LevelListItem>> getFutureLevelList(String? str) {
    return futureLevelList!;
  }

  NewBookingBloc._internal() : super(const NewBookingState()) {
    PlanBloc().stream.listen((state) {
      if (state is PlanLoadedState) {
        selectedDate = state.selectedDate;
      }
      if (state is PlanWorkplaceSelectedState) {
        selectedWorkspaceId = state.selectedWorkspace!.id;
        print('------------------------------------------------------');
        print(
            "NewBookingBloc accept new selectedWorkspaceId: $selectedWorkspaceId");
        print('------------------------------------------------------');
        selectedDate = state.selectedDate;
        emit(NewBookingFifthState(
            futureCityList!,
            selectedCity!.name,
            futureOfficeListItem!,
            selectedOffice!.address,
            getFutureLevelList,
            selectedLevel!));
      } else {
        emit(NewBookingFourthState(
            futureCityList!,
            selectedCity!.name,
            futureOfficeListItem!,
            selectedOffice!.address,
            getFutureLevelList,
            selectedLevel!));
      }
    });

    NewBookingSheetBloc().stream.listen((state) {
      if (state is NewBookingSheetLoadedState) {
        if (state.rangeList.isNotEmpty) {
          var sfr = state.rangeValuesList[state.activeSliderIndex];
          selectedDateTimeRange = DateTimeRange(start: sfr.start, end: sfr.end);
        }
      }
    });

    // on<NewBookingReloadCitiesEvent>((event, emit) {
    //   try {
    //     futureCityList = CityRepository().getAllCities();
    //   } catch (_) {
    //     try {
    //       futureCityList = CityRepository().getAllCities();
    //     } catch (_) {}
    //   }
    // });
    on<NewBookingInitialEvent>((event, emit) async {
      futureCityList = CityRepository().getAllCities();
      emit(NewBookingFirstState(futureCityList!, ''));
    });
    on<NewBookingCityFormEvent>((event, emit) {
      selectedCity = event.city;
      futureOfficeListItem =
          OfficeRepository().getOfficesByCityId(selectedCity!.id);
      emit(NewBookingSecondState(
          futureCityList!, selectedCity!.name, futureOfficeListItem!, ''));
    });
    on<NewBookingOfficeFormEvent>((event, emit) {
      selectedOffice = event.office;
      futureOfficeListItem =
          OfficeRepository().getOfficesByCityId(selectedCity!.id);
      futureLevelList =
          OfficeRepository().getLevelsByOfficeId(selectedOffice!.id);
      emit(NewBookingThirdState(
          futureCityList!,
          selectedCity!.name,
          futureOfficeListItem!,
          selectedOffice!.address,
          getFutureLevelList,
          null));
    });

    on<NewBookingLevelFormEvent>((event, emit) {
      selectedLevel = event.level;
      PlanBloc().add(PlanClearTitleEvent());
      PlanBloc().add(PlanLoadEvent(selectedLevel!.id,selectedOffice!.maxBookingRangeInDays));
      emit(NewBookingFourthState(
          futureCityList!,
          selectedCity!.name,
          futureOfficeListItem!,
          selectedOffice!.address,
          getFutureLevelList,
          selectedLevel!));
    });

    on<NewBookingButtonTimeEvent>((event, emit) {
      NewBookingSheetBloc()
          .add(NewBookingSheetLoadEvent(selectedWorkspaceId!, selectedDate!));
    });

    on<NewBookingBookEvent>((event, emit) async {
      try {
        int userId = await SecurityStorage().getIdStorage();
        NewBookingConfirmationPopupBloc()
            .add(NewBookingConfirmationLoadEvent());
        List<int> guestsIds = guests.map((e) => e.id).toList();
        if (NewBookingSheetBloc().workspace!.numberOfWorkspaces <= 1) {
          guestsIds = [];
        }
        await BookingRepository().book(
            selectedWorkspaceId!, userId, selectedDateTimeRange!, guestsIds);
        NewBookingConfirmationPopupBloc()
            .add(NewBookingConfirmationSuccessEvent());
        NewBookingSheetBloc()
            .add(NewBookingSheetLoadEvent(selectedWorkspaceId!, selectedDate!));
        BookingListBloc().add(BookingListLoadEvent());
        setGuests([]);
        NewBookingSheetBloc().add(NewBookingSheetAddingPeopleToBookingEvent(const []));
        ///обнуляем добавленных гостей для следуещей брони если эта успешна
      } catch (_) {
        NewBookingConfirmationPopupBloc()
            .add(NewBookingConfirmationErrorEvent());
      }
    });
    add(NewBookingInitialEvent());
  }
}
