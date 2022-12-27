part of 'plan_bloc.dart';

@immutable
abstract class PlanState {
  final DateTime selectedDate;

  PlanState(this.selectedDate);
}

class PlanHidedState extends PlanState {
  PlanHidedState(super.selectedDate);

}
class PlanLoadingState extends PlanState {
  PlanLoadingState(super.selectedDate);
}
class PlanLoadedState extends PlanState {
  final String title;
  final double height;
  final double width;
  //final Image background;
  final List<LevelPlanElementData> workspaces;
  final LevelPlanElementData? selectedWorkspace;
  final Map<int,WorkspaceType> workspaceTypes;
  final int? levelPlanImageId;
  PlanLoadedState(DateTime selectedDate,this.workspaces,this.workspaceTypes, this.height, this.width, this.selectedWorkspace, this.title, this.levelPlanImageId,)
      : super(selectedDate);
}
class PlanWorkplaceSelectedState extends PlanState {
  final String title;
  final double height;
  final double width;
  //final Image background;
  final List<LevelPlanElementData> workspaces;
  final LevelPlanElementData? selectedWorkspace;
  final Map<int,WorkspaceType> workspaceTypes;
  final int? levelPlanImageId;
  PlanWorkplaceSelectedState(DateTime selectedDate, this.workspaces,this.workspaceTypes, this.height, this.width, this.selectedWorkspace, this.title, this.levelPlanImageId)
  : super(selectedDate);
}
class PlanErrorState extends PlanState {
  PlanErrorState(super.selectedDate);

}
