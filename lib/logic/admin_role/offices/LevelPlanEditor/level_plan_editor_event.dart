part of 'level_plan_editor_bloc.dart';

@immutable
abstract class LevelPlanEditorEvent {}

class LevelPlanEditorElementMoveEvent extends LevelPlanEditorEvent {
  final int id;

  final double newPositionX;
  final double newPositionY;

  LevelPlanEditorElementMoveEvent(
      this.id, this.newPositionY, this.newPositionX);
}

class LevelPlanEditorElementChangeSizeEvent extends LevelPlanEditorEvent {
  final int id;

  final double newWidth;
  final double newHeight;

  LevelPlanEditorElementChangeSizeEvent(this.id, this.newWidth, this.newHeight);
}

class LevelPlanEditorSelectElementEvent extends LevelPlanEditorEvent {
  final int id;

  LevelPlanEditorSelectElementEvent(
    this.id,
  );
}

class LevelPlanEditorDeselectElementEvent extends LevelPlanEditorEvent {
}

class LevelPlanEditorCreateElementEvent extends LevelPlanEditorEvent {
  final WorkspaceType type;

  LevelPlanEditorCreateElementEvent(this.type);
}

class LevelPlanEditorForceUpdateEvent extends LevelPlanEditorEvent {}

class LevelPlanEditorDeleteWorkspaceButtonPressEvent
    extends LevelPlanEditorEvent {}

class LevelPlanEditorChangeLevelFieldEvent extends LevelPlanEditorEvent {
  final String newLevelForm;

  LevelPlanEditorChangeLevelFieldEvent(this.newLevelForm);
}

class LevelPlanEditorChangeDescriptionFieldEvent extends LevelPlanEditorEvent {
  final String form;

  LevelPlanEditorChangeDescriptionFieldEvent(this.form);
}

class LevelPlanEditorChangeNumberOfWorkplacesFieldEvent
    extends LevelPlanEditorEvent {
  final int countOfWorkplaces;

  LevelPlanEditorChangeNumberOfWorkplacesFieldEvent(this.countOfWorkplaces);
}

class LevelPlanEditorChangeActiveStatusEvent extends LevelPlanEditorEvent {}

class LevelPlanEditorLoadWorkspacesFromServerEvent extends LevelPlanEditorEvent{
  final int levelId;
  final int? preselectWorkspaceId;

  LevelPlanEditorLoadWorkspacesFromServerEvent(this.levelId, [this.preselectWorkspaceId]);
}
class LevelPlanEditorSendChangesToServerEvent extends LevelPlanEditorEvent{

}

class LevelPlanEditorDeleteLevelEvent extends LevelPlanEditorEvent{

}
class LevelPlanEditorAddImageToWorkspaceButtonEvent extends LevelPlanEditorEvent{
  final ImageSource source;
  LevelPlanEditorAddImageToWorkspaceButtonEvent(this.source);
}
class LevelPlanEditorChangeBackgroundButtonEvent extends LevelPlanEditorEvent{
}
class LevelPlanEditorDeleteWorkspacePhotoEvent extends LevelPlanEditorEvent{
  final int imageId;

  LevelPlanEditorDeleteWorkspacePhotoEvent(this.imageId);
}