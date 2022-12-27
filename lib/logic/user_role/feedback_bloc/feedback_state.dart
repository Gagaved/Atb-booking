part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackState {}

class FeedbackMainState extends FeedbackState {

  final bool typeFieldVisible;
  final bool cityFieldVisible;
  final bool officeFieldVisible;
  final bool levelFieldVisible;
  final bool workplaceFieldVisible;
  final bool messageFieldVisible;
  final bool buttonVisible;
  bool isInitialState = false;

  final String? selectedType;
  final  City? selectedCityId;
  final Office? selectedOffice;
  final LevelListItem? selectedLevelId;

  final List<LevelPlanElementData>? listOfPlanElements;
  final int? selectedElementIndex;


  final int? levelPlanImageId;
  final String message;

  FeedbackMainState(
      this.typeFieldVisible,
      this.cityFieldVisible,
      this.officeFieldVisible,
      this.levelFieldVisible,
      this.workplaceFieldVisible,
      this.messageFieldVisible,
      this.buttonVisible,
      this.selectedType,
      this.selectedCityId,
      this.selectedOffice,
      this.selectedLevelId,
      this.levelPlanImageId,
      this.listOfPlanElements,
      this.selectedElementIndex,
      this.message);
}

abstract class FeedbackPopupState extends FeedbackState {}

class FeedbackSuccessState extends FeedbackMainState {
  FeedbackSuccessState(super.typeFieldVisible, super.cityFieldVisible, super.officeFieldVisible, super.levelFieldVisible, super.workplaceFieldVisible, super.messageFieldVisible, super.buttonVisible, super.selectedType, super.selectedCityId, super.selectedOffice, super.selectedLevelId, super.levelPlanImageId, super.listOfPlanElements, super.selectedElementIndex, super.message);
}

class FeedbackPopupLoadingState extends FeedbackMainState {
  FeedbackPopupLoadingState(super.typeFieldVisible, super.cityFieldVisible, super.officeFieldVisible, super.levelFieldVisible, super.workplaceFieldVisible, super.messageFieldVisible, super.buttonVisible, super.selectedType, super.selectedCityId, super.selectedOffice, super.selectedLevelId, super.levelPlanImageId, super.listOfPlanElements, super.selectedElementIndex, super.message);
}

class FeedbackPopupErrorState extends FeedbackMainState {
  FeedbackPopupErrorState(super.typeFieldVisible, super.cityFieldVisible, super.officeFieldVisible, super.levelFieldVisible, super.workplaceFieldVisible, super.messageFieldVisible, super.buttonVisible, super.selectedType, super.selectedCityId, super.selectedOffice, super.selectedLevelId, super.levelPlanImageId, super.listOfPlanElements, super.selectedElementIndex, super.message);
}
