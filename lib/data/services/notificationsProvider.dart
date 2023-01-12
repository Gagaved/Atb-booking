import 'dart:convert';

import 'package:atb_booking/data/models/notificathions.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:http/http.dart' as http;

class NotificationsProvider {
  Future<void> deleteNotification(int id) async {
    ///Получаем access токен
    var token = await NetworkController().getAccessToken();

    /// Создаем headers
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';

    var baseUrl = NetworkController().getUrl();
    var uri = Uri.https(baseUrl, 'api/notification/$id');
    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      /// Если 401, то обновляем access токен
      await NetworkController().updateAccessToken();
      deleteNotification(id);
    } else {
      throw Exception('Error delete notifications');
    }
  }

  Future<List<NotificationsModel>> getNotifications(int page, int size) async {
    Map<String, dynamic> queryParameters = {}
      ..["page"] = page.toString()
      ..["size"] = size.toString();

    /// Создание headers запроса
    Map<String, String> headers = {};
    headers = await NetworkController().getAuthHeader();
    headers["Content-type"] = 'application/json';

    /// Получаю id
    int id = await SecurityStorage().getIdStorage();

    /// Сам запрос
    var uri = Uri.https(
        NetworkController().getUrl(), '/api/notification/$id', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> usersRow = dataJson["content"];
      return usersRow.map((json) => NotificationsModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getNotifications(page, size);
    } else {
      throw Exception('Error fetching All Notifications');
    }
  }
}
