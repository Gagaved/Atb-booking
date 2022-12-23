import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/feedback_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  String message = '';
  bool buttonVisible = false;
  User? currentUser;
  List<String> dropdownListItems = <String>[
    'Отзыв о работе приложения',
    'Жалоба на пользователя',
    'Жалоба на рабочее место'
  ];

  ComplaintBloc() : super(ComplaintInitialState()) {
    emit(ComplaintLoadingState());
    on<ComplaintStartingEvent>((event, emit) {
      currentUser = event.user;
      emit(ComplaintLoadedState(showButton: false, userPerson: currentUser!)..isInitial);
    });
    on<ComplaintMessageInputEvent>((event, emit) {
      message = event.form;
      buttonVisible = (message != '');
      emit(ComplaintLoadedState(
          showButton: buttonVisible, userPerson: currentUser!));
    });
    on<ComplaintSubmitEvent>((event, emit) async {
      emit(ComplaintLoadedState(showButton: false, userPerson: currentUser!));
      int feedbackTypeId = 2;
      int? officeId = null;
      int? officeLevelId = null;
      int? workplaceId = null;
      int? guiltyId = event.userId;

      try {
        emit(ComplaintLoadingState());
        await FeedbackProvider().createFeedbackMessage(
            message, feedbackTypeId, officeId, officeLevelId, workplaceId, guiltyId);
        emit(ComplaintSuccessState());
      } catch (_) {
        emit(ComplaintErrorState(currentUser));
      }
    });
  }
}
