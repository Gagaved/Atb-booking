import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../data/authController.dart';
import '../secure_storage_api.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    bool _validateFindError(String login, String password) {
      // проверка ПУСТОЕ ли поле
      if (login.trim().isEmpty || password.trim().isEmpty) {
        // trim() убирает пробелы в начале и конце строки
        emit(AuthErrorState(message: "not correct input"));
        return true;
      }
      // проверка СКОЛЬКО СИМВОЛОВ в поле
      if (login.length < 4 || password.length < 4) {
        emit(AuthErrorState(message: "not correct input"));
        return true;
      }
      // проверка НА КИРИЛЛИЦУ в поле
      RegExp exp = RegExp(r'[а-яА-Я]');
      if (login.contains(exp) || password.contains(exp)) {
        emit(AuthErrorState(message: "not correct input"));
        return true;
      }
      // иначе все збс
      return false;
    }

    on<AuthStartEvent>((event, emit) {
      emit(AuthInitialState());
    });
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());

      /// Валидация
      bool validatorError = _validateFindError(event.login, event.password);
      if (validatorError == true) return; //* валидатор уже кинул ошибку клиенту

      try {
        /// Запрос и сохранение результата (возвращает тип пользователя)
        String type = await AuthController().login(event.login, event.password);
        print('USERTYPE IS: $type');

        /// Проверка сохранять ли пользователя
        if (event.isChecked == true) {
          SecurityStorage().saveLoginStorage(event.login); // save login
        }

        /// Маршрутизация по пользователю
        if (type == "USER") {
          emit(AuthUserSuccessState());
        } else if (type == "ADMIN") {
          emit(AuthAdminSuccessState());
        } else {
          emit(AuthErrorState(
              message: "Сервер вернул неизвестный тип пользователя"));
        }
      } catch (_) {
        emit(AuthErrorState(message: "not correct login"));
      }
    });
  }
}
