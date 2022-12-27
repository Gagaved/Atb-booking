part of 'admin_people_bloc.dart';

@immutable
abstract class AdminPeopleEvent {}

class AdminPeopleLoadEvent extends AdminPeopleEvent {
  final String form;
  final bool formHasBeenChanged;
  AdminPeopleLoadEvent(this.form, this.formHasBeenChanged);
}

class AdminPeopleLoadNextPageEvent extends AdminPeopleEvent {}
