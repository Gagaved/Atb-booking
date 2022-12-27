part of 'people_bloc.dart';

@immutable
abstract class PeopleState {
  final bool isFavoriteOn;
  final List<User> users;
  const PeopleState(this.isFavoriteOn, this.users);
}

class PeopleInitialState extends PeopleState {
  const PeopleInitialState(super.isFavoriteOn, super.users);
}

class PeopleEmptyState extends PeopleState {
  const PeopleEmptyState(super.isFavoriteOn, super.users);
}

class PeopleLoadingState extends PeopleState {
  final int page;
  const PeopleLoadingState(super.isFavoriteOn, super.users, this.page);
}

class PeopleLoadedState extends PeopleState {
  final bool formHasBeenChanged;
  const PeopleLoadedState(super.isFavoriteOn, super.users, this.formHasBeenChanged);
}
