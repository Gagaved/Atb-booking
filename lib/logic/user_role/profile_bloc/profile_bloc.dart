import 'package:atb_booking/data/models/notificathions.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/data/services/notificationsProvider.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user.dart';
import '../../../data/services/users_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static final ProfileBloc _singleton = ProfileBloc._internal();

  factory ProfileBloc() {
    return _singleton;
  }

  ProfileBloc._internal() : super(ProfileLoadingState()) {
    on<ProfileLoadEvent>((event, emit) async {
      try {
        emit(ProfileLoadingState());
        int id = await SecurityStorage().getIdStorage();
        User user = await UsersRepository().getUserById(id);
        List<NotificationsModel> notificationsList =
            await NotificationsProvider().getNotifications(0, 10);
        emit(ProfileLoadedState(userPerson: user, notificationsList: notificationsList));
      } catch (e) {
        emit(ProfileErrorState());
      }
    });

    on<ProfileExitToAuthEvent>((event, emit) async {
      /// Выход для бека
      NetworkController().exitFromApp();
    });
    //emit(ProfileLoadingState());
    add(ProfileLoadEvent());
  }
}
