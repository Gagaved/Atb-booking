part of 'complaint_bloc.dart';

@immutable
abstract class ComplaintState {}

class ComplaintInitialState extends ComplaintState {}

class ComplaintLoadingState extends ComplaintState {}

class ComplaintLoadedState extends ComplaintState {
  bool isInitial = false;
  final bool showButton;
  final User userPerson;
  ComplaintLoadedState({required this.userPerson, required this.showButton});
}

class ComplaintSuccessState extends ComplaintState {}

class ComplaintErrorState extends ComplaintState {
  final User? currentUser;
  ComplaintErrorState(this.currentUser);
}
