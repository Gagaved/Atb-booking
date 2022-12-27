part of 'locked_plan_bloc.dart';

@immutable
abstract class LockedPlanState {

  const LockedPlanState();
}
class LockedPlanInitState extends LockedPlanState{
}
class LockedPlanLoadingState extends LockedPlanState {
}
class LockedPlanLoadedState extends LockedPlanState {
  final double height;
  final double width;
  final List<LevelPlanElementData> workspaces;
  final int selectedWorkspaceId;
  final Map<int,WorkspaceType> workspaceTypes;
  final int? levelPlanImageId;
  const LockedPlanLoadedState(this.workspaces,this.workspaceTypes, this.height, this.width, this.selectedWorkspaceId,  this.levelPlanImageId,);
}
class LockedPlanErrorState extends LockedPlanState {
  const LockedPlanErrorState();
}
