part of 'admin_offices_bloc.dart';

@immutable
abstract class AdminOfficesEvent {}
class AdminOfficesCitySelectedEvent extends AdminOfficesEvent{
  final City city;

  AdminOfficesCitySelectedEvent(this.city);
}

class AdminOfficesReloadEvent extends AdminOfficesEvent{
}