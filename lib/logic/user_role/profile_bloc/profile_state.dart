part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User userPerson;
  final List<NotificationsModel> notificationsList;
  ProfileLoadedState(
      {required this.userPerson, required this.notificationsList});
}

class ProfileErrorState extends ProfileState {}
