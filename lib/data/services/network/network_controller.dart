import 'dart:convert';
import 'package:atb_booking/data/authController.dart';

import 'package:http/http.dart' as http;

import '../../../logic/secure_storage_api.dart';

class NetworkController {
  NetworkController._internal();
  static final NetworkController _singleton = NetworkController._internal();
  factory NetworkController() {
    return _singleton;
  }
  void exitFromApp(){
    AuthController().exitFromApp();
    /// Чистка SecurityStorage
    SecurityStorage().clearValueStorage();
  }
  final _baseUrl = "45.67.58.123:8080";
  // final _baseUrl = "atb-booking.tk:8080";
  //final _baseUrl = "85.192.32.12:8080";
  String getUrl() => _baseUrl;


  /// Возвращает access токен (обращаемся во всех provider)
  Future<String> getAccessToken() async {
    return await SecurityStorage().getAccessTokenStorage();
  }

  Map<String, String> getAuthHeader() {
    Map<String, String> headers = {};
    var token = SecurityStorage().getAccessTokenStorageCYNC();
    headers["Authorization"] = 'Bearer $token';
    return headers;
  }

  /// Метод обновления access токена
  Future<void> updateAccessToken() async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Получение Refresh токена
    String refreshToken = await SecurityStorage().getRefreshTokenStorage();

    /// Создаем header
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $accessToken';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";

    /// Сам запрос
    var uri = Uri.http(_baseUrl, '/api/auth/access-token/$refreshToken');
    var response = await http.post(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      /// Если все ок, то сохраняем новый токен
      final dynamic dataJson = json.decode(response.body);
      final String newAccess = dataJson["accessToken"];
      await SecurityStorage().saveAccessTokenStorage(newAccess);
    } else if (response.statusCode == 401) {
      /// Если 401, то обновляем все токены
      await NetworkController().updateAllTokens();
    } else {
      throw (ExceptionAccessTokenError);
    }
  }

  /// Метод обновления всех токенов
  Future<void> updateAllTokens() async {
    /// Получение Refresh токена
    String refreshToken = await SecurityStorage().getRefreshTokenStorage();

    /// Сам запрос
    var uri = Uri.http(_baseUrl, '/api/auth/refresh-token/$refreshToken');
    var response = await http.post(uri, headers: {});

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(response.body);
      final String newAccess = dataJson["accessToken"];
      final String newRefresh = dataJson["refreshToken"];
      await SecurityStorage().saveAccessTokenStorage(newAccess);
      await SecurityStorage().saveRefreshTokenStorage(newRefresh);
    } else {
      throw (ExceptionAllTokensError);
    }
  }

  /// Метод разлогировании пользователя
  Future<void> logoutTokens() async {
    /// Получение токенов
    String accessToken = await NetworkController().getAccessToken();
    String refreshToken = await SecurityStorage().getRefreshTokenStorage();

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Сам запрос
    var uri = Uri.http(_baseUrl, '/api/auth/logout/$refreshToken');
    var response = await http.post(uri, headers: headers);

    /// Проверка
    if (response.statusCode != 200) {
      throw (ExceptionLogoutError);
    }
  }
}

class ExceptionAccessTokenError implements Exception {}

class ExceptionAllTokensError implements Exception {}

class ExceptionLogoutError implements Exception {}
