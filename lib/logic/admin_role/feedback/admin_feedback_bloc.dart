import 'package:atb_booking/data/models/feedback.dart';
import 'package:atb_booking/data/services/feedback_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_feedback_event.dart';
part 'admin_feedback_state.dart';

class AdminFeedbackBloc extends Bloc<AdminFeedbackEvent, AdminFeedbackState> {
  static List<String> dropdownList = <String>[
    'Отзыв о работе приложения',
    'Жалоба на пользователя',
    'Жалоба на рабочее место'
  ];
  int page = 0;
  static const int size = 10;
  int typeId = 1;
  List<FeedbackItem> feedbackListItems = [];
  bool formHasBeenChanged = true;

  /// При старте показывает "Отзыв о работе приложения"
  AdminFeedbackBloc() : super(AdminFeedbackMainState(1, dropdownList, [])) {
    on<AdminFeedbackType_ApplicationMessageEvent>((event, emit) {
      formHasBeenChanged = true;
      feedbackListItems = [];
      typeId = 1;
      add(AdminFeedbackLoadEvent(formHasBeenChanged));
    });
    on<AdminFeedbackType_UserComplaintEvent>((event, emit) {
      formHasBeenChanged = true;
      feedbackListItems = [];
      typeId = 2;
      add(AdminFeedbackLoadEvent(formHasBeenChanged));
    });
    on<AdminFeedbackType_WorkplaceComplaintEvent>((event, emit) {
      formHasBeenChanged = true;
      feedbackListItems = [];
      typeId = 3;
      add(AdminFeedbackLoadEvent(formHasBeenChanged));
    });
    on<AdminFeedbackLoadNextPageEvent>((event, emit) {
      formHasBeenChanged = false;
      page++;
      add(AdminFeedbackLoadEvent(formHasBeenChanged));
    });
    on<AdminFeedbackLoadEvent>((event, emit) async {
      emit(AdminFeedbackLoadingState(
          typeId, dropdownList, feedbackListItems, event.formHasBeenChanged));

      if (event.formHasBeenChanged) page = 0;
      if (page == 0) {
        feedbackListItems = [];
      }

      try {
        var newLoadFeedback =
            await FeedbackProvider().getFeedbackByType(page, size, typeId);
        feedbackListItems.addAll(newLoadFeedback);
      } catch (e) {
        emit(AdminFeedbackErrorState(typeId, dropdownList, feedbackListItems));
        print("Error into AdminFeedbackLoadEvent: ${e.toString()}");
        throw (e);
      }

      emit(AdminFeedbackMainState(typeId, dropdownList, feedbackListItems));
    });
    on<AdminFeedbackDeleteItemEvent>((event, emit) async {
      feedbackListItems.remove(event.feedbackItem);
      try {
        await FeedbackProvider().deleteFeedback(event.feedbackItem.id);
        emit(AdminFeedbackMainState(typeId, dropdownList, feedbackListItems));
      } catch (e) {
        emit(AdminFeedbackErrorState(typeId, dropdownList, feedbackListItems));
        print("Error delete feedback in bloc: $e");
      }
    });

    add(AdminFeedbackType_ApplicationMessageEvent());
  }
}
