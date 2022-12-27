import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/users_provider.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_sheet_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'adding_people_to_booking_event.dart';

part 'adding_people_to_booking_state.dart';

class AddingPeopleToBookingBloc
    extends Bloc<AddingPeopleToBookingEvent, AddingPeopleToBookingState> {
  bool isFavoriteOn = false;
  int page = 0;
  String currentForm = "";
  List<User> loadedUsers = [];
  Map<int, User> selectedUsers = {};

  AddingPeopleToBookingBloc(List<User> userList)
      : super(AddingPeopleToBookingInitial(false, {})) {
    selectedUsers = {};
    for (var element in userList) {
      selectedUsers[element.id] = element;
    }
    on<AddingPeopleToBookingIsFavoriteChangeEvent>((event, emit) async {
      isFavoriteOn = event.isFavoriteOn;
      add(AddingPeopleLoadEvent(event.form, true));
    });
    on<AddingPeopleLoadEvent>((event, emit) async {
      print("Load event");
      emit(AddingPeopleToBookingLoadingState(
          isFavoriteOn, selectedUsers, loadedUsers));
      currentForm = event.form;
      if (event.formHasBeenChanged) page = 0;
      if (page == 0) {
        loadedUsers = [];
      }
      var users = await UsersProvider()
          .fetchUsersByName(page, 10, currentForm, isFavoriteOn);
      loadedUsers.addAll(users);
      print("UNDER EMIT LOADED STATE");
      emit(AddingPeopleToBookingLoadedState(
          isFavoriteOn, selectedUsers, loadedUsers));
    });
    on<AddingPeopleToBookingLoadNextPageEvent>((event, emit) async {
      page++;
      add(AddingPeopleLoadEvent(currentForm, false));
    });
    on<AddingPeopleToBookingSelectUserEvent>((event, emit) async {
      selectedUsers[event.selectedUser.id] = event.selectedUser;
      emit(AddingPeopleToBookingLoadedState(
          isFavoriteOn, selectedUsers, loadedUsers));
    });
    on<AddingPeopleToBookingDeselectUserEvent>((event, emit) async {
      selectedUsers.remove(event.selectedUser.id);
      emit(AddingPeopleToBookingLoadedState(
          isFavoriteOn, selectedUsers, loadedUsers));
    });
    on<AddingPeopleToBookingButtonPressEvent>((event, emit) async {
      NewBookingSheetBloc().add(NewBookingSheetAddingPeopleToBookingEvent(
          selectedUsers.entries.map((e) => e.value).toList()));
    });
    on<AddingPeopleToBookingToFavoriteEvent>((event, emit) async {
      event.user.isFavorite = true;
      // todo отправить на сервер
      emit(AddingPeopleToBookingLoadedState(
          isFavoriteOn, selectedUsers, loadedUsers));
      try {
        // int curUserId = await SecurityStorage().getIdStorage();
        UsersProvider().addFavorite(event.user.id);
      } catch (_) {
        event.user.isFavorite = false;
      }
    });
    on<AddingPeopleToBookingRemoveFromFavoriteEvent>((event, emit) async {
      event.user.isFavorite = false;
      emit(AddingPeopleToBookingLoadedState(
          isFavoriteOn, selectedUsers, loadedUsers));
      // int curUserId = await SecurityStorage().getIdStorage();
      try {
        UsersProvider().deleteFromFavorites(event.user.id);
      } catch (_) {
        event.user.isFavorite = true;
      }
    });
    emit(AddingPeopleToBookingLoadedState(
        isFavoriteOn, selectedUsers, loadedUsers));
  }
}
