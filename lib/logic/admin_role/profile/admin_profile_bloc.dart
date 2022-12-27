import 'package:atb_booking/data/authController.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/users_repository.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_profile_event.dart';
part 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  AdminProfileBloc() : super(AdminProfileLoadingState()) {
    on<AdminProfileLoadEvent>((event, emit) async {
      try {
        emit(AdminProfileLoadingState());
        int id = await SecurityStorage().getIdStorage();
        User user = await UsersRepository().getUserById(id);
        emit(AdminProfileLoadedState(userPerson: user));
      } catch (e) {
        emit(AdminProfileErrorState());
      }
    });

    on<AdminProfileExitToAuthEvent>((event, emit) async {
      /// Выход для бека
      await AuthController().exitFromApp();

      /// Чистка SecurityStorage
      await SecurityStorage().clearValueStorage();
    });
    add(AdminProfileLoadEvent());
  }
}
