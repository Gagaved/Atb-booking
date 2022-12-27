part of 'admin_people_bloc.dart';

@immutable
abstract class AdminPeopleState {
  final List<User> users;

  const AdminPeopleState(this.users);
}

class AdminPeopleInitialState extends AdminPeopleState {
  const AdminPeopleInitialState(super.users);
}

class AdminPeopleEmptyState extends AdminPeopleState {
  const AdminPeopleEmptyState(super.users);
}

class AdminPeopleLoadingState extends AdminPeopleState {
  final int page;
  const AdminPeopleLoadingState(super.users, this.page);
}

class AdminPeopleLoadedState extends AdminPeopleState {
  final bool formHasBeenChanged;

  const AdminPeopleLoadedState(super.users, this.formHasBeenChanged);
}
