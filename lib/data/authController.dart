import 'dart:convert';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:http/http.dart' as http;

import '../logic/secure_storage_api.dart';
import 'models/login.dart';

class AuthController {
  static String? role;
  static int? currentUserId;
  var uri = Uri.http(
    NetworkController().getUrl(),
    '/api/auth/login',
  );

  /// Функция возвращает тип пользователя
  Future<String> login(String login, String password) async {
    /// Создание тела запроса
    var newJson = <String, dynamic>{};
    newJson["login"] = login;
    newJson["password"] = password;
    var encoded = jsonEncode(newJson);
    /// Создание headers запроса
    Map<String, String> headers = {};
    headers["Content-type"] = 'application/json';
    headers["Access-Control-Allow-Origin"] = '*';
    headers["Access-Control-Allow-Headers"] = '*';
    headers["Access-Control-Allow-Methods"] = '*';

    /// Вызов POST запроса
    var response = await http.post(uri, headers: headers, body: encoded);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Login resData = Login.fromJson(data);
      /// Сохранение токенов и id
      await SecurityStorage().saveIdStorage(resData.userId);
      await SecurityStorage().saveAccessTokenStorage(resData.access);
      await SecurityStorage().saveRefreshTokenStorage(resData.refresh);
      await SecurityStorage().saveTypeStorage(resData.type);
      currentUserId = resData.userId;
      role = resData.type;
      print("role: $role");
      //* TODO нужно переделать сохранения типа********

      return resData.type;
    } else {
      throw "Auth controller problem";
    }
  }

  /// Функция разлогирования
  Future<void> exitFromApp() async {
    /// Получаем refresh токен и добавляем его в url
    final String refresh = await SecurityStorage().getRefreshTokenStorage();
    var uri = Uri.http(
      NetworkController().getUrl(),
      '/api/auth/logout/$refresh',
    );

    /// Вызов POST запроса
    var response = await http.post(uri, headers: {}, body: {});

    if (response.statusCode != 200) {
      throw "Logout problem in controller";
    }
  }
}
