part of 'admin_profile_bloc.dart';

@immutable
abstract class AdminProfileEvent {}

class AdminProfileLoadEvent extends AdminProfileEvent {}

class AdminProfileExitToAuthEvent extends AdminProfileEvent {}
