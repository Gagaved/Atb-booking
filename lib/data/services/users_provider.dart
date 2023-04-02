import 'dart:convert';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:http/http.dart' as http;

import '../models/role.dart';
import '../models/user.dart';
import 'network/network_controller.dart';

class UsersProvider {
  UsersProvider._internal() {}
  static final UsersProvider _singleton = UsersProvider._internal();

  factory UsersProvider() {
    return _singleton;
  }

  final baseUrl = NetworkController().getUrl();

  Future<User> fetchUserById(int id) async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Сам запрос
    var uri = Uri.http(baseUrl, '/api/users/$id');
    var response = await http.get(uri, headers: headers);
    final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));

    /// Проверка ответа
    if (response.statusCode == 200) {
      User persons = User.  fromJson(dataJson);
      print(json.decode(utf8.decode(response.bodyBytes)));
      return persons;
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchUserById(id);
    } else {
      throw Exception('Error fetching user by id');
    }
  }

  Future<List<User>> fetchAllUsers(int page, int size, String sort) async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Создание параметров
    Map<String, dynamic> queryParameters = {}
      ..["page"] = page.toString()
      ..["size"] = size.toString()
      ..["sortParameter"] = sort;

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Сам запрос
    var uri = Uri.http(baseUrl, '/api/users', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> usersRow = dataJson["content"];
      return usersRow.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchAllUsers(page, size, sort);
    } else {
      throw Exception('Error fetching All users');
    }
  }

  Future<List<User>> fetchUsersByName(
      int page, int size, String userName, bool isFavorites) async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();
    int currentUserId = await SecurityStorage().getIdStorage();
    /// Создание параметров
    Map<String, dynamic> queryParameters = {}
      ..["page"] = page.toString()
      ..["size"] = size.toString()
      ..["userName"] = userName
      ..["isFavorites"] = isFavorites.toString();

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Сам запрос
    var uri =
        Uri.http(baseUrl, '/api/users/search/$currentUserId', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> usersRow = dataJson["content"];
      return usersRow.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchUsersByName(page, size, userName, isFavorites);
    } else {
      throw Exception('Error fetching All users');
    }
  }

  Future<List<Role>> fetchUsersRoles() async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Сам запрос
    var uri = Uri.http(baseUrl, '/api/users/role');
    var response = await http.get(uri, headers: headers);

    /// Проверка ответа
    if (response.statusCode == 200) {
      final List<dynamic> dataJson = json.decode(response.body);
      return dataJson.map((json) => Role.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchUsersRoles();
    } else {
      throw Exception('Error fetching users roles');
    }
  }

  Future<List<User>> fetchUserFavorites(int id) async {
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Создание headers
    Map<String, String> headers = {"Authorization": 'Bearer $accessToken'};

    /// Создание параметров
    Map<String, dynamic> queryParameters = {}..["userId"] = id.toString();

    /// Сам запрос
    var uri = Uri.http(baseUrl, '/api/favorites', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка ответа
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> favoritesRow = dataJson["favorites"];
      return favoritesRow.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchUserFavorites(id);
    } else {
      throw Exception('Error fetching favorites');
    }
  }

  Future<void> addFavorite(int favoriteId) async  {
    var currentUserId = await SecurityStorage().getIdStorage();
    var uri = Uri.http(
      baseUrl,
      '/api/favorites/$favoriteId/users/$currentUserId',
    );

    /// Создание тела запроса
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();
    /// Создание headers запроса
    Map<String, String> headers = {};
    headers["Content-type"] = 'application/json';
    headers["Authorization"] = 'Bearer $accessToken';

    /// Вызов POST запроса
    var response = await http.post(uri, headers: headers,);

    if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return addFavorite(favoriteId);
    } else if (response.statusCode != 201) {
      throw Exception('Error creation favorite');
    }
  }

  Future<void> deleteFromFavorites(int favoriteId) async {
    var currentUserId = await SecurityStorage().getIdStorage();
    var uri = Uri.http(
      baseUrl,
      '/api/favorites/$favoriteId/users/$currentUserId',
    );

    /// Создание тела запроса
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();

    /// Создание headers запроса
    Map<String, String> headers = {};
    headers["Content-type"] = 'application/json';
    headers["Authorization"] = 'Bearer $accessToken';

    /// Вызов POST запроса
    var response = await http.delete(uri, headers: headers,);

    if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return deleteFromFavorites(favoriteId);
    } else if (response.statusCode != 200) {
      throw Exception('Error creation favorite bad response. response code: ${response.statusCode}');
    }
  }
}
