import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/services/level_plan_provider.dart';
import 'package:atb_booking/data/services/office_provider.dart';
import 'package:atb_booking/data/services/office_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'admin_office_page_event.dart';

part 'admin_office_page_state.dart';

class AdminOfficePageBloc
    extends Bloc<AdminOfficePageEvent, AdminOfficePageState> {
  Office? office;
  String? address;
  int? bookingRange = 5;
  DateTimeRange? workTimeRange;
  List<LevelListItem>? levels;

  bool isSaveButtonActive() {
    return !(office!.address == address &&
        office!.workTimeRange == workTimeRange &&
        office!.maxBookingRangeInDays == bookingRange);
  }

  AdminOfficePageBloc() : super(AdminOfficePageInitial()) {
    on<OfficePageLoadEvent>((event, emit) async {
      print("emit loading state");
      emit(AdminOfficePageLoadingState());
      try {
        print("emit loaded state");
        office = await OfficeProvider().getOfficeById(event.officeId);
        levels = await OfficeRepository().getLevelsByOfficeId(office!.id);
        address = office!.address;
        bookingRange = office!.maxBookingRangeInDays;
        workTimeRange = office!.workTimeRange;
        emit(AdminOfficePageLoadedState(office!.id, address!, bookingRange!, workTimeRange!,
            isSaveButtonActive(), levels!));
      } catch (_) {
        print(_);
        emit(AdminOfficePageErrorState());
      }
    });
    on<OfficePageReloadEvent>((event, emit) async {
      print("reload office page");
      try {
        office = await OfficeProvider().getOfficeById(office!.id);
        levels = await OfficeRepository().getLevelsByOfficeId(office!.id);
        address = office!.address;
        bookingRange = office!.maxBookingRangeInDays;
        workTimeRange = office!.workTimeRange;
        print("emit loaded state after reload ");
        emit(AdminOfficePageLoadedState(office!.id,address!, bookingRange!, workTimeRange!,
            isSaveButtonActive(), levels!));
      } catch (_) {
        print("emit error state after reload ");
        emit(AdminOfficePageErrorState());
      }
    });

    on<AdminOfficeDeleteEvent>((event, emit) async {
      try {
        emit(AdminOfficePageDeleteLoadingState(office!.id,address!, bookingRange!,
            workTimeRange!, isSaveButtonActive(), levels!));
        await OfficeProvider().deleteOfficeById(office!.id);
        emit(AdminOfficePageDeleteSuccessState(office!.id,address!, bookingRange!,
            workTimeRange!, isSaveButtonActive(), levels!));
      } catch (_) {
        emit(AdminOfficePageDeleteErrorState(office!.id,address!, bookingRange!,
            workTimeRange!, isSaveButtonActive(), levels!));
      }
    });

    on<AdminOfficePageCreateNewLevelButtonPress>((event, emit) async {
      int number = 1;
      for (var level in levels!) {
        if (number <= level.number) {
          number = level.number + 1;
        }
      }
      try {
        int createdLevelId =
            await LevelProvider().createLevel(office!.id, number);
        emit(AdminOfficePageSuccessCreateLevelState(office!.id,address!, bookingRange!,
            workTimeRange!, isSaveButtonActive(), levels!, createdLevelId));
      } catch (_) {
        AdminOfficePageErrorCreateLevelState(office!.id,
          address!,
          bookingRange!,
          workTimeRange!,
          isSaveButtonActive(),
          levels!,
        );
        print(_);
      }
      add(OfficePageReloadEvent());
    });
    on<AdminOfficeAddressChangeEvent>((event, emit) {
      address = event.address;
      print("emit loaded state");
      emit(AdminOfficePageLoadedState(office!.id,address!, bookingRange!, workTimeRange!,
          isSaveButtonActive(), levels!));

      /// эмитить не нужно потом что textfield изменяется сам. контроллер - статик
    });
    on<AdminBookingRangeChangeEvent>((event, emit) {
      bookingRange = event.bookingRange;
      print("emit loaded state");
      // emit(AdminOfficePageLoadedState(address!,bookingRangeDays!)); /// эмитить не нужно потом что textfield изменяется сам, потому что контроллер статик
    });
    on<AdminOfficeSaveChangesButtonEvent>((event, emit) async {
      var newOfficeData = Office(
          id: office!.id,
          address: address!,
          maxBookingRangeInDays: bookingRange!,
          workTimeRange: workTimeRange!);
      try {
        await OfficeProvider().changeOffice(newOfficeData);
        office = newOfficeData;
        emit(AdminOfficePageLoadedState(office!.id,address!, bookingRange!, workTimeRange!,
            isSaveButtonActive(), levels!));
      } catch (_) {
        print(_);
        add(OfficePageLoadEvent(office!.id));
      }
    });
    on<AdminOfficePageUpdateFieldsEvent>((event, emit) {
      emit(AdminOfficePageLoadedState(office!.id,address!, bookingRange!, workTimeRange!,
          isSaveButtonActive(), levels!));
    });
    on<AdminOfficePageWorkRangeChangeEvent>((event, emit) {
      workTimeRange = event.newWorkTimeRange;
      emit(AdminOfficePageLoadedState(office!.id,address!, bookingRange!, workTimeRange!,
          isSaveButtonActive(), levels!));
    });
  }
}
