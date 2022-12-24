import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/level_plan_repository.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'plan_event.dart';

part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  static final PlanBloc _singleton = PlanBloc._internal();

  factory PlanBloc() {
    return _singleton;
  }

  static const double WIDTH = 350;
  static const double HEIGHT = 350;
  static const String _defaultTitle = "Выберите место для бронирования";
  Level? levelPlan;
  int? maxBookingRangeInDays;
  Map<int, WorkspaceType>? workspaceTypes;
  LevelPlanElementData? selectedWorkspace;
  DateTime selectedDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour).add(const Duration(days: 1));
  final LevelPlanRepository levelPlanRepository = LevelPlanRepository();
  final WorkspaceTypeRepository workspaceTypeRepository =
      WorkspaceTypeRepository();
  PlanBloc._internal() : super(PlanHidedState(DateTime.now())) {
    on<PlanTapElementEvent>((event, emit) async {
      try {
        if (selectedWorkspace == event.workspace) {
          selectedWorkspace = null;
          emit(PlanLoadedState(
            selectedDate,
            levelPlan!.workspaces,
            workspaceTypes!,
            HEIGHT,
            WIDTH,
            selectedWorkspace,
            selectedWorkspace == null
                ? _defaultTitle
                : selectedWorkspace!.type.type,
              levelPlan!.planId
          ));
        } else {
          selectedWorkspace = event.workspace;
          emit(PlanWorkplaceSelectedState(
            selectedDate,
            levelPlan!.workspaces,
            workspaceTypes!,
            HEIGHT,
            WIDTH,
            selectedWorkspace,
            selectedWorkspace == null
                ? _defaultTitle
                : workspaceTypes![selectedWorkspace!.type.id]!.type,
              levelPlan!.planId
          ));
        }
      } catch (_) {}
    });
    on<PlanLoadEvent>((event, emit) async {
      try {
        maxBookingRangeInDays = event.maxBookingRangeInDays;
        workspaceTypes = await workspaceTypeRepository.getMapOfTypes();
        levelPlan = await levelPlanRepository.getPlanByLevelId(event.levelId);
        emit(PlanLoadedState(
          selectedDate,
          levelPlan!.workspaces,
          workspaceTypes!,
          HEIGHT,
          WIDTH,
          selectedWorkspace,
          selectedWorkspace == null
              ? _defaultTitle
              : selectedWorkspace!.type.type,
            levelPlan!.planId
        ));
      } catch (_) {
        emit(PlanErrorState(selectedDate));
      }
    });
    on<PlanHideEvent>((event, emit) async {
      try {
        emit(PlanHidedState(selectedDate));
      } catch (_) {
        emit(PlanErrorState(selectedDate));
      }
    });
    on<PlanSelectDateEvent>((event, emit) async {
      try {
        selectedDate = event.dateTime;
        NewBookingBloc().selectedDate = selectedDate;//todo replace to event
              } catch (_) {
        emit(PlanErrorState(selectedDate));
      }
    });
    on<PlanClearTitleEvent> ((event,emit)async {
      selectedWorkspace = null;
    });
  }
}
