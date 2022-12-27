import 'dart:convert';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

class BookingProvider {
  Future<void> book(int workspaceId, int userId, DateTimeRange dateTimeRange,
      List<int> guestsIds) async {
    ///
    /// Получение Access токена
    String accessToken = await NetworkController().getAccessToken();
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $accessToken';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(
      baseUrl,
      '/api/reservations',
    );

    ///
    print("-------------");
    print("-------------");
    print("БРОНИРУЕМ...");
    print("WorkspaceID: $workspaceId");
    print("Дата СТАРТА брони:" + dateTimeRange.start.toUtc().toIso8601String());
    print("Дата КОНЦА брони" + dateTimeRange.end.toUtc().toIso8601String());
    print(".............");

    ///
    var interval = <String, String>{};
    interval["startsAt"] = dateTimeRange.start.toUtc().toIso8601String();
    interval["endsAt"] = dateTimeRange.end.toUtc().toIso8601String();
    var json = <String, dynamic>{};
    json["workspaceId"] = workspaceId;
    json["userId"] = userId;
    json["interval"] = interval;
    json["guests"] = guestsIds;
    var encoded = jsonEncode(json);

    var response = await http.post(uri, headers: headers, body: encoded);

    print("Status code: ${response.statusCode}");
    if (response.statusCode == 201) {
      print("-------------");
      print("УСПЕШНО ЗАБРОНИРОВАННО");
      print("-------------");
      return;
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return book(workspaceId, userId, dateTimeRange, guestsIds);
    } else {
      throw Exception('Error booking post');
    }
  }

  Future<List<Booking>> getBookingsByUserId(int id,{required bool isHolder, required bool isGuest}) async {
    if(isHolder == false && isGuest ==false){
      print("bad param to getBookingByUserId");
      throw Exception("getBookingsByUserId bad request: isHolder == false and isGuest == false");
    }
    print("PROVIDER getBookingByUserId");
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    Map<String, dynamic> queryParameters = {};
    queryParameters["isHolder"] = isHolder.toString();
    queryParameters["isGuest"] = isGuest.toString();
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';

    var uri = Uri.http(baseUrl, '/api/reservations/user/$id',queryParameters);
    print("Uri:");
    print(uri.toString());
    var response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      print("successful fetching booking!");
      final List<dynamic> bookingJson =
          json.decode(utf8.decode(response.bodyBytes));
      var bookingList =
          bookingJson.map((json) => Booking.fromJson(json)).toList();
      print(bookingList);
      return bookingList;
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getBookingsByUserId(id,isHolder: isHolder,isGuest: isGuest);
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      throw Exception('Error fetching booking');
    }
  }

  Future<Booking> getBookingById(int id) async {
    print("PROVIDER getBookingById");

    Map<String, String> headers = {};
    var baseUrl = NetworkController().getUrl();
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';

    var uri = Uri.http(baseUrl, '/api/reservations/$id');
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      final Map<String, dynamic> bookingJson =
          json.decode(utf8.decode(response.bodyBytes));
      return Booking.fromJson(bookingJson);
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getBookingById(id);
    } else {
      throw Exception('Error fetching booking');
    }
  }

  Future<List<DateTimeRange>> getBookingWindows(int id, DateTime date) async {
    Map<String, dynamic> queryParameters = {};
    Map<String, String> headers = {};
    var baseUrl = NetworkController().getUrl();
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    queryParameters["date"] = date.toUtc().toIso8601String();
    queryParameters["workspaceId"] = id.toString();

    ///
    print('ПОЛУЧАЕМ ОКНА...');
    print('WorkspaceID:$id');
    print('Дата по которой получаем окна: ' + date.toUtc().toIso8601String());
    print('---------------');

    var uri = Uri.http(baseUrl, '/api/reservations', queryParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      final List<dynamic> windowsJson =
          json.decode(utf8.decode(response.bodyBytes))['freeIntervals'];
      var result = windowsJson
          .map((json) => (DateTimeRange(
                start: DateTime.parse(json['startsAt']).toLocal(),
                end: DateTime.parse(json['endsAt']).toLocal(),
              )))
          .toList();
      print('СПИСОК ОКОН ДЛЯ БРОНИРОВАНИЯ');
      for (var element in result) {
        print("-------------------------------");
        print("Начало окона: " + element.start.toUtc().toIso8601String());
        print("Конец окона: " + element.end.toUtc().toIso8601String());
        print('--------------------------------');
      }

      ///
      /// УБИРАЕМ БАГ БОРИ НА НУЛЕВОЕ ОКНО
      result.removeWhere((element) => element.start == element.end);

      ///
      ///
      return result;
    } else if (response.statusCode == 401) {
      /// Если 401, то обновляем все токены
      await NetworkController().updateAllTokens();
      return getBookingWindows(id, date);
    } else {
      print('````````````````');
      print('ОШИБКА ПОЛУЧЕНИЯ ОКОН');
      print("response code: ${response.statusCode}");
      print('````````````````');
      throw Exception('Error fetching windows');
    }
  }

  Future<void> deleteBooking(int id) async {
    print("PROVIDER deleteBooking");

    Map<String, String> headers = {};
    var baseUrl = NetworkController().getUrl();
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    var uri = Uri.http(baseUrl, '/api/reservations/$id');
    var response = await http.delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      /// Если 401, то обновляем все токены
      await NetworkController().updateAllTokens();
      deleteBooking(id);
    } else {
      throw Exception('Error delete booking');
    }
  }
}
