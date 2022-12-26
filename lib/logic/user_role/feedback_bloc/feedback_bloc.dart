import 'package:atb_booking/data/models/city.dart';
import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/services/feedback_provider.dart';
import 'package:atb_booking/data/services/level_plan_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'feedback_event.dart';

part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  static Future<List<String>> getFutureTypeList(String? str) async {
    List<String> type = ["Отзыв", "Жалоба на место"];
    return type;
  }

  /// Необходимые поля
  int? selectedWorkspaceId;
  Level? level;

  //
  String? selectedType;
  City? selectedCity;
  Office? selectedOffice;
  LevelListItem? selectedLevel;

  List<LevelPlanElementData>? listOfPlanElements;

  // LevelPlanElementData? selectedWorkplace;
  int? selectedWorkplaceId;
  int? selectedElementIndex;
  String message = '';

  ///
  int? levelImageId;
  bool? typeFieldVisible;
  bool? cityFieldVisible;
  bool? officeFieldVisible;
  bool? levelFieldVisible;
  bool? workplaceFieldVisible;
  bool? messageFieldVisible;
  bool? buttonVisible;

  /// Обработчик событий
  FeedbackBloc()
      : super(FeedbackMainState(true, false, false, false, false, false, false,
            null, null, null, null, null, null, null, '')
          ..isInitialState = true) {
    on<FeedbackTypeFormEvent>((event, emit) {
      typeFieldVisible = true;
      cityFieldVisible = false;
      officeFieldVisible = false;
      levelFieldVisible = false;
      workplaceFieldVisible = false;
      messageFieldVisible = false;
      buttonVisible = false;
      //
      selectedType = event.type;
      selectedCity = null;
      selectedOffice = null;
      selectedLevel = null;
      if (selectedType == "Отзыв") {
        messageFieldVisible = true;
        buttonVisible = (message != '');
        emit(FeedbackMainState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            null,
            selectedElementIndex,
            message));
      } else {
        cityFieldVisible = true;
        emit(FeedbackMainState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            null,
            selectedElementIndex,
            message));
      }
    });
    on<FeedbackCityFormEvent>((event, emit) async {
      typeFieldVisible = true;
      cityFieldVisible = true;
      officeFieldVisible = true;
      levelFieldVisible = false;
      workplaceFieldVisible = false;
      messageFieldVisible = false;
      buttonVisible = false;
      //
      selectedCity = event.city;
      selectedOffice = null;
      selectedLevel = null;
      emit(FeedbackMainState(
          typeFieldVisible!,
          cityFieldVisible!,
          officeFieldVisible!,
          levelFieldVisible!,
          workplaceFieldVisible!,
          messageFieldVisible!,
          buttonVisible!,
          selectedType,
          selectedCity,
          selectedOffice,
          selectedLevel,
          levelImageId,
          null,
          selectedElementIndex,
          message));
    });
    on<FeedbackOfficeFormEvent>((event, emit) {
      typeFieldVisible = true;
      cityFieldVisible = true;
      officeFieldVisible = true;
      levelFieldVisible = true;
      workplaceFieldVisible = false;
      messageFieldVisible = false;
      buttonVisible = false;
      //
      selectedOffice = event.office;
      selectedLevel = null;

      emit(FeedbackMainState(
          typeFieldVisible!,
          cityFieldVisible!,
          officeFieldVisible!,
          levelFieldVisible!,
          workplaceFieldVisible!,
          messageFieldVisible!,
          buttonVisible!,
          selectedType,
          selectedCity,
          selectedOffice,
          selectedLevel,
          levelImageId,
          null,
          selectedElementIndex,
          message));
      on<FeedbackLevelFormEvent>((event, emit) async {
        typeFieldVisible = true;
        cityFieldVisible = true;
        officeFieldVisible = true;
        levelFieldVisible = true;
        workplaceFieldVisible = true;
        messageFieldVisible = false;
        buttonVisible = false;
        //
        selectedLevel = event.level;

        try {
          level = await LevelProvider().getPlanByLevelId(selectedLevel!.id);
          levelImageId = level!.planId;
        } catch (e) {
          throw (e);
        }

        // PlanBloc().add(PlanClearTitleEvent());
        // PlanBloc().add(PlanLoadEvent(
        //     selectedLevel!.id, selectedOffice!.maxBookingRangeInDays));
        emit(FeedbackMainState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));
      });
      on<FeedbackWorkplaceTapEvent>((event, emit) {
        typeFieldVisible = true;
        cityFieldVisible = true;
        officeFieldVisible = true;
        levelFieldVisible = true;
        workplaceFieldVisible = true;
        messageFieldVisible = true;
        buttonVisible = false;
        //
        if (selectedWorkplaceId == event.workplaceId) {
          selectedWorkplaceId = null;
          messageFieldVisible = false;
        } else {
          selectedWorkplaceId = event.workplaceId;
          selectedElementIndex = null;
          for (int i = 0; i < listOfPlanElements!.length; i++) {
            if (listOfPlanElements![i].id == selectedWorkplaceId) {
              selectedElementIndex = i;
              break;
            }
          }
          messageFieldVisible = true;
        }

        emit(FeedbackMainState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));
      });

      on<FeedbackMessageInputEvent>((event, emit) {
        message = event.form;
        buttonVisible = (message != '');
        emit(FeedbackMainState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));
      });
      on<FeedbackButtonSubmitEvent>((event, emit) async {
        int feedbackTypeId = 1;
        int? officeId = null;
        int? workplaceId = null;
        int? guiltyId = null;

        if (selectedType == "Жалоба на место") {
          feedbackTypeId = 3;
          officeId = selectedOffice!.id;
        }

        try {
          emit(FeedbackPopupLoadingState(
              typeFieldVisible!,
              cityFieldVisible!,
              officeFieldVisible!,
              levelFieldVisible!,
              workplaceFieldVisible!,
              messageFieldVisible!,
              buttonVisible!,
              selectedType,
              selectedCity,
              selectedOffice,
              selectedLevel,
              levelImageId,
              listOfPlanElements,
              selectedElementIndex,
              message));
          await FeedbackProvider().createFeedbackMessage(
              message,
              feedbackTypeId,
              officeId,
              selectedLevel!.id,
              workplaceId,
              guiltyId);
          emit(FeedbackSuccessState(
              typeFieldVisible!,
              cityFieldVisible!,
              officeFieldVisible!,
              levelFieldVisible!,
              workplaceFieldVisible!,
              messageFieldVisible!,
              buttonVisible!,
              selectedType,
              selectedCity,
              selectedOffice,
              selectedLevel,
              levelImageId,
              listOfPlanElements,
              selectedElementIndex,
              message));
        } catch (e) {
          emit(FeedbackPopupErrorState(
              typeFieldVisible!,
              cityFieldVisible!,
              officeFieldVisible!,
              levelFieldVisible!,
              workplaceFieldVisible!,
              messageFieldVisible!,
              buttonVisible!,
              selectedType,
              selectedCity,
              selectedOffice,
              selectedLevel,
              levelImageId,
              listOfPlanElements,
              selectedElementIndex,
              message));
        }
      });
    });
    on<FeedbackLevelFormEvent>((event, emit) async {
      try {
        selectedLevel = event.level;
        level = await LevelProvider().getPlanByLevelId(selectedLevel!.id);
        listOfPlanElements = level!.workspaces;
        levelImageId = level!.planId;

        typeFieldVisible = true;
        cityFieldVisible = true;
        officeFieldVisible = true;
        levelFieldVisible = true;
        workplaceFieldVisible = true;
        messageFieldVisible = false;
        buttonVisible = false;
        //

      } catch (e) {
        throw (e);
      }

      emit(FeedbackMainState(
          typeFieldVisible!,
          cityFieldVisible!,
          officeFieldVisible!,
          levelFieldVisible!,
          workplaceFieldVisible!,
          messageFieldVisible!,
          buttonVisible!,
          selectedType,
          selectedCity,
          selectedOffice,
          selectedLevel,
          levelImageId,
          listOfPlanElements,
          selectedElementIndex,
          message));
    });

    on<FeedbackWorkplaceTapEvent>((event, emit) {
      selectedWorkplaceId = event.workplaceId;
      for (int i = 0; i < listOfPlanElements!.length; i++) {
        if (listOfPlanElements![i].id == selectedWorkplaceId) {
          selectedElementIndex = i;
          break;
        }
      }

      typeFieldVisible = true;
      cityFieldVisible = true;
      officeFieldVisible = true;
      levelFieldVisible = true;
      workplaceFieldVisible = true;
      messageFieldVisible = true;
      buttonVisible = (message != '');

      emit(FeedbackMainState(
          typeFieldVisible!,
          cityFieldVisible!,
          officeFieldVisible!,
          levelFieldVisible!,
          workplaceFieldVisible!,
          messageFieldVisible!,
          buttonVisible!,
          selectedType,
          selectedCity,
          selectedOffice,
          selectedLevel,
          levelImageId,
          listOfPlanElements,
          selectedElementIndex,
          message));
    });
    on<FeedbackMessageInputEvent>((event, emit) {
      message = event.form;
      buttonVisible = (message != '');
      emit(FeedbackMainState(
          typeFieldVisible!,
          cityFieldVisible!,
          officeFieldVisible!,
          levelFieldVisible!,
          workplaceFieldVisible!,
          messageFieldVisible!,
          buttonVisible!,
          selectedType,
          selectedCity,
          selectedOffice,
          selectedLevel,
          levelImageId,
          listOfPlanElements,
          selectedElementIndex,
          message));
    });
    on<FeedbackButtonSubmitEvent>((event, emit) async {
      int feedbackTypeId = 1;
      int? officeId = null;
      int? workplaceId = null;
      int? guiltyId = null;
      int? selectedLevelId = null;
      if (selectedLevel != null) {
        selectedLevelId = selectedLevel!.id;
      }

      if (selectedType == "Жалоба на место") {
        feedbackTypeId = 3;
        officeId = selectedOffice!.id;
      }

      try {
        emit(FeedbackPopupLoadingState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));

            if(selectedElementIndex != null){
              await FeedbackProvider().createFeedbackMessage(message, feedbackTypeId,
                  officeId, selectedLevelId, listOfPlanElements![selectedElementIndex!].id, guiltyId);
            }else{
              await FeedbackProvider().createFeedbackMessage(message, feedbackTypeId,
                  officeId, selectedLevelId, null, guiltyId);
            }


        emit(FeedbackSuccessState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));
      } catch (e) {
        emit(FeedbackPopupErrorState(
            typeFieldVisible!,
            cityFieldVisible!,
            officeFieldVisible!,
            levelFieldVisible!,
            workplaceFieldVisible!,
            messageFieldVisible!,
            buttonVisible!,
            selectedType,
            selectedCity,
            selectedOffice,
            selectedLevel,
            levelImageId,
            listOfPlanElements,
            selectedElementIndex,
            message));
      }
    });
  }
}
