import 'dart:convert';

import 'package:atb_booking/data/models/feedback.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:http/http.dart' as http;

class FeedbackProvider {
  Future<void> createFeedbackMessage(
      String message,
      int feedbackTypeId,
      int? officeId,
      int? officeLevelId,
      int? workplaceId,
      int? guiltyId) async {

    int id = await SecurityStorage().getIdStorage();
    var uri = Uri.http(
      NetworkController().getUrl(),
      '/api/feedbacks/$id',
    );

    DateTime date = DateTime.now().toUtc();

    /// Создание тела запроса
    var newJson = <String, dynamic>{};
    newJson["comment"] = message;
    newJson["feedbackTypeId"] = feedbackTypeId.toString();
    newJson["officeId"] = officeId.toString();
    newJson["officeLevelId"] = officeLevelId.toString();
    newJson["workplaceId"] = workplaceId.toString();
    newJson["guiltyId"] = guiltyId.toString();
    newJson["date"] = date.toUtc().toIso8601String();
    var encoded = jsonEncode(newJson);
    print("newJson: $newJson");

    /// Создание headers запроса
    Map<String, String> headers = {};
    headers = await NetworkController().getAuthHeader();
    headers["Content-type"] = 'application/json';

    /// Вызов POST запроса
    var response = await http.post(uri, headers: headers, body: encoded);
    print("res STATUS: ${response.statusCode}");

    if (response.statusCode == 401) {
      await NetworkController().updateAccessToken();
      createFeedbackMessage(message, feedbackTypeId, officeId, officeLevelId,
          workplaceId, guiltyId);
    } else if (response.statusCode != 201) {
      throw Exception("Error Feedback Creating In Provider");
    }
  }

  Future<List<FeedbackItem>> getFeedbackByType(
      int page, int size, int filterByFeedbackTypeId) async {
    /// Создание параметров
    Map<String, dynamic> queryParameters = {}
      ..["page"] = page.toString()
      ..["size"] = size.toString()
      ..["filterByFeedbackTypeId"] = filterByFeedbackTypeId.toString()
      ..["filterByOfficeId"] = "0";

    /// Создание headers запроса
    Map<String, String> headers = {};
    headers = await NetworkController().getAuthHeader();
    headers["Content-type"] = 'application/json';

    int id = await SecurityStorage().getIdStorage();
    /// Сам запрос
    var uri = Uri.http(
        NetworkController().getUrl(), '/api/feedbacks/all/$id', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> usersRow = dataJson["content"];
      return usersRow.map((json) => FeedbackItem.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getFeedbackByType(page, size, filterByFeedbackTypeId);
    } else {
      throw Exception('Error fetching All users');
    }
  }

  Future<List<FeedbackItem>> getFeedbackByOfficeId(
      int page, int size, int filterByOfficeId) async {
    /// Создание параметров
    Map<String, dynamic> queryParameters = {}
      ..["page"] = page.toString()
      ..["size"] = size.toString()
      ..["filterByFeedbackTypeId"] = '0'
      ..["filterByOfficeId"] = filterByOfficeId.toString();

    /// Создание headers запроса
    Map<String, String> headers = {};
    headers = await NetworkController().getAuthHeader();
    headers["Content-type"] = 'application/json';

    /// Сам запрос
    var uri = Uri.http(
        NetworkController().getUrl(), '/api/feedbacks', queryParameters);
    var response = await http.get(uri, headers: headers);

    /// Проверка
    if (response.statusCode == 200) {
      final dynamic dataJson = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> usersRow = dataJson["content"];
      return usersRow.map((json) => FeedbackItem.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getFeedbackByOfficeId(page, size, filterByOfficeId);
    } else {
      throw Exception('Error fetching All users');
    }
  }

  /// Запрос на удаление
  Future<void> deleteFeedback(int id) async {
    ///Получаем access токен
    var token = await NetworkController().getAccessToken();

    /// Создаем headers
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';

    var baseUrl = NetworkController().getUrl();
    var uri = Uri.http(baseUrl, '/api/feedbacks/$id');
    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      /// Если 401, то обновляем access токен
      await NetworkController().updateAccessToken();
      deleteFeedback(id);
    } else {
      throw Exception('Error delete feedback');
    }
  }
}
