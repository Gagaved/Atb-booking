import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:atb_booking/presentation/interface/app_in.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

/// Функция возвращает значение просил ли пользователь его запомнить
Future<bool> _remember() async {
  /// Если помнит логин то значит пользователь просил запомнить
  final String login = await SecurityStorage().getLoginStorage();
  if (login != '') {
    return true;
  } else {
    return false;
  }
}

void main() async {
  /// Проверка для авторизации
  WidgetsFlutterBinding.ensureInitialized();
  String type = '';
  if (await _remember()) {
    type = await SecurityStorage().getTypeStorage();
  }

  initializeDateFormatting();
  runApp(Application(
    typeUser: type,
  ));
}
