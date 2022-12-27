import 'package:atb_booking/data/services/users_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:atb_booking/data/models/user.dart';

part 'people_event.dart';

part 'people_state.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  bool isFavoriteOn = false;
  int page = 0;
  String currentForm = '';
  List<User> loadedUsers = [];
  PeopleBloc() : super(const PeopleInitialState(false, [])) {
    on<PeopleIsFavoriteChangeEvent>((event, emit) {
      isFavoriteOn = !isFavoriteOn;
      add(PeopleLoadEvent(event.form, true));
    });
    on<PeopleLoadEvent>((event, emit) async {
      emit(PeopleLoadingState(isFavoriteOn, loadedUsers,page));
      currentForm = event.form;
      if (event.formHasBeenChanged) page = 0;
      if (page == 0) {
        loadedUsers = [];
      }
      var users = await UsersProvider()
          .fetchUsersByName(page, 10, event.form, isFavoriteOn);
      loadedUsers.addAll(users);
      emit(PeopleLoadedState(
          isFavoriteOn, loadedUsers, event.formHasBeenChanged));
    });
    on<PeopleLoadNextPageEvent>((event, emit) async {
      page++;
      add(PeopleLoadEvent(currentForm, false));
    });
    on<PeopleAddingToFavoriteEvent>((event, emit) async {
      event.user.isFavorite = true;
      try {
        UsersProvider().addFavorite(event.user.id);
      } catch (_) {
        event.user.isFavorite = false;
      }
      emit(PeopleLoadedState(isFavoriteOn, loadedUsers, false));
    });
    on<PeopleRemoveFromFavoriteEvent>((event, emit) {
      event.user.isFavorite = false;
      loadedUsers.remove(event.user);
      try {
        UsersProvider().deleteFromFavorites(event.user.id);
      } catch (_) {
        event.user.isFavorite = true;
      }
      emit(PeopleLoadedState(isFavoriteOn, loadedUsers, false));
    });
  }
}
