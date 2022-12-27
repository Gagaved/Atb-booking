part of 'admin_profile_bloc.dart';

@immutable
abstract class AdminProfileState {}

class AdminProfileInitialState extends AdminProfileState {}

class AdminProfileLoadingState extends AdminProfileState {}

class AdminProfileLoadedState extends AdminProfileState {
  final User userPerson;
  AdminProfileLoadedState({required this.userPerson});
}

class AdminProfileErrorState extends AdminProfileState {}
