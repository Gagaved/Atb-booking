import 'dart:convert';
import 'dart:io';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:http/http.dart' as http;

class AppImageProvider {
  static String getImageUrlFromImageId(int id) {
    var baseUrl = NetworkController().getUrl();
    var uri = Uri.http(baseUrl, "/api/images/$id");
    return uri.toString();
  }

  static Future<int> upload(File file) async {
    //create multipart request for POST or PATCH method
    var baseUrl = NetworkController().getUrl();
    var uri = Uri.http(baseUrl, '/api/images');
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    var request = http.MultipartRequest(
      "POST",
      uri,
    );
    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-type"] = 'application/json; charset=utf-8';
    request.headers["Accept"] = "application/json";
    //add text fields
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    int idOfCreatedPhoto = json.decode(utf8.decode(responseData))['id'];
    print(responseString);
    return idOfCreatedPhoto;
  }
}
