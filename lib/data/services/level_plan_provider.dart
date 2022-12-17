import 'dart:convert';

import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:http/http.dart' as http;
import '../models/level_plan.dart';

class LevelProvider {
  Future<Level> getPlanByLevelId(int id) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(baseUrl, '/api/officeLevels/levelWithWorkplaces/$id');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return Level.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getPlanByLevelId(id);
    } else {
      throw Exception('Error fetching level');
    }
  }

  Future<void> putNewLevelInfo(Level level) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var jsonLevel = level.toJson();
    var body = jsonEncode(jsonLevel);
    var uri = Uri.http(baseUrl, '/api/officeLevels/${level.id}');
    final response = await http.put(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      print("successful put new level info");
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return putNewLevelInfo(level);
    } else {
      print("'Error fetching level status code: ${response.statusCode}");
      throw Exception('Error fetching level');
    }
  }

  Future<int> createLevel(int officeId, int number) async {
    var jsonLevel = <String, dynamic>{};
    //json['id'] = id;
    jsonLevel["number"] = number;
    jsonLevel["officeId"] = officeId;
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var body = jsonEncode(jsonLevel);
    var uri = Uri.http(baseUrl, '/api/officeLevels');
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 201) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      int id = jsonResponse['id'];
      print("successful create new level");
      return id;
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return createLevel(officeId, number);
    } else {
      print("'Error create level status code: ${response.statusCode}");
      throw Exception('Error fetching level');
    }
  }

  Future<void> deleteLevel(int levelId) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(baseUrl, '/api/officeLevels/${levelId}');
    final response = await http.delete(uri, headers: headers,);
    if (response.statusCode == 200) {
    print("successful delete level");
    } else if (response.statusCode == 401) {
    /// Обновление access токена
    await NetworkController().updateAccessToken();
    return deleteLevel(levelId);
    } else {
    print("'Error delete level status code: ${response.statusCode}");
    throw Exception('Error fetching level');
    }
  }
}
