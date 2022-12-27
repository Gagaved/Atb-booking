part of 'level_plan_editor_bloc.dart';

@immutable
abstract class LevelPlanEditorState {}

class LevelPlanEditorInitial extends LevelPlanEditorState {}

class LevelPlanEditorMainState extends LevelPlanEditorState{
  final List<LevelPlanElementData> listOfPlanElements;
  final int levelNumber;
  final int? selectedElementIndex;
  final int? levelPlanImageId;
  final List<int> selectedWorkspacePhotosIds;
  LevelPlanEditorMainState({ required this.selectedElementIndex, required this.listOfPlanElements,required this.levelNumber, required this.levelPlanImageId,required this.selectedWorkspacePhotosIds});
}
class LevelPlanEditorLoadingState extends LevelPlanEditorState{

}