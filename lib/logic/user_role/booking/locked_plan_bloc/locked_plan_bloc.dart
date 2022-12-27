import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../data/models/level_plan.dart';
import '../../../../../data/models/workspace.dart';
import '../../../../../data/models/workspace_type.dart';
import '../../../../../data/services/level_plan_repository.dart';
import '../../../../../data/services/workspace_type_repository.dart';
part 'locked_plan_event.dart';

part 'locked_plan_state.dart';

class LockedPlanBloc extends Bloc<LockedPlanEvent, LockedPlanState> {
  static final LockedPlanBloc _singleton = LockedPlanBloc._internal();

  factory LockedPlanBloc() {
    return _singleton;
  }
  static const double WIDTH = 350;
  static const double HEIGHT = 350;
  Level? levelPlan;
  Map<int, WorkspaceType>? workspaceTypes;
  int? selectedWorkspaceId;
  final LevelPlanRepository levelPlanRepository = LevelPlanRepository();
  final WorkspaceTypeRepository workspaceTypeRepository =
      WorkspaceTypeRepository();
  LockedPlanBloc._internal() : super(LockedPlanInitState()) {
    on<LockedPlanLoadEvent>((event, emit) async {
      try {
        workspaceTypes = await workspaceTypeRepository.getMapOfTypes();
        Level levelPlan = await levelPlanRepository.getPlanByLevelId(event.levelId);
        selectedWorkspaceId = event.workspaceId;
        emit(LockedPlanLoadedState(
          levelPlan.workspaces,
          workspaceTypes!,
          HEIGHT,
          WIDTH,
          selectedWorkspaceId!, levelPlan.planId
        ));
      } catch (_) {
        emit(LockedPlanErrorState());
      }
    });
  }
}
