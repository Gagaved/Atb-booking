import 'dart:convert';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class CityProvider {
  Future<List<City>> getCitiesByName(String pattern) async {
    print("PROVIDER getAllCities");
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    Map<String, dynamic> queryParameters = {};
    queryParameters["cityName"] = pattern;
    var uri = Uri.http(baseUrl, '/api/cities',queryParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> cityJson =
      json.decode(utf8.decode(response.bodyBytes));
      return cityJson.map((json) => City.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getAllCities();
    } else {
      throw Exception('Error fetching cities');
    }
  }
  Future<List<City>> getAllCities() async {
    print("PROVIDER getAllCities");
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    Map<String, dynamic> queryParameters = {};
    queryParameters["cityName"] = "";
    var uri = Uri.http(baseUrl, '/api/cities',queryParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> cityJson =
          json.decode(utf8.decode(response.bodyBytes));
      return cityJson.map((json) => City.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return getAllCities();
    } else {
      throw Exception('Error fetching cities');
    }
  }
}
