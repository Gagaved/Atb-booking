import 'dart:convert';
import 'dart:io';

import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/offices/LevelPlanEditor/level_plan_editor_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/workspace.dart';

class WorkspaceProvider {
  Future<Workspace> fetchWorkspaceById(int id) async {
    print("PROVIDER fetchWorkspaceById");
    Map<String, dynamic> queryParameters = {};
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(baseUrl, '/api/workspaces/$id', queryParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return Workspace.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return fetchWorkspaceById(id);
    } else {
      throw Exception('Error fetching workspace');
    }
  }

  Future<int> createWorkspaceByLevelPlanEditorElementData(
      LevelPlanElementData element) async {
    print("PROVIDER create workspace");
    var jsonOfElement = element.toJson();
    var body = jsonEncode(jsonOfElement);
    print(body);
    Map<String, dynamic> queryParameters = {};
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(baseUrl, '/api/workspaces', queryParameters);
    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 201) {
      int id = (json.decode(utf8.decode(response.bodyBytes)))["id"]!;
      print("successful create workspace, id: $id");
      return (id);
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return createWorkspaceByLevelPlanEditorElementData(element);
    } else {
      print("error create workspace, status code: ${response.statusCode}");
      throw Exception('Error create workspace');
    }
  }

  Future<void> deleteById(int imageId) async {
    print("PROVIDER create workspace");
    Map<String, dynamic> queryParameters = {};
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri =
        Uri.http(baseUrl, '/api/workspaces/$imageId', queryParameters);
    var response = await http.delete(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print("successful delete workspacePhoto id:${imageId}");
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return deleteById(imageId);
    } else if (response.statusCode == 404) {
      print("already deleted");
    } else {
      print("error delete workspace, status code: ${response.statusCode}");
      throw Exception('Error create workspace');
    }
  }

  Future<void> sendWorkspacesChangesByLevelId(
      List<LevelPlanElementData> listOfChangedWorkspaces) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var list = <dynamic>[];
    for (var elem in listOfChangedWorkspaces) {
      var jsonElem = elem.toJson();
      list.add((jsonElem));
    }
    var body = jsonEncode(list);
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var uri = Uri.http(baseUrl, '/api/workspaces');
    final response = await http.put(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      print("successful put workspaces!");
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return sendWorkspacesChangesByLevelId(listOfChangedWorkspaces);
    } else {
      print("response code: ${response.statusCode}");
      throw Exception('Error fetching level');
    }
  }

  Future<void> addPhotoToWorkspaceByIds(int workspaceId, int photosId) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var fields = <String, dynamic>{};
    fields['imageId'] = photosId;
    fields['workspaceId'] = workspaceId;
    var body = jsonEncode(fields);
    var uri = Uri.http(baseUrl, '/api/workspacesPhoto');
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 201) {
      print("successful create workspaces photo!");
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return addPhotoToWorkspaceByIds(workspaceId, photosId);
    } else {
      print("response code: ${response.statusCode}");
      throw Exception('Error create workspaces photo');
    }
  }
  Future<void> uploadWorkspacePhoto(File file,workspaceId) async {
    //create multipart request for POST or PATCH method
    var baseUrl = NetworkController().getUrl();
    var uri = Uri.http(baseUrl,'/api/workspacesPhoto/$workspaceId');
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
    if(response.statusCode == 201){
      print("success load photo to workspace");
    }else if (response.statusCode == 401){
      await NetworkController().updateAccessToken();
      return uploadWorkspacePhoto(file,workspaceId);
    }else{
      throw Exception("error loading photo");
    }
    //Get the response from the server

  }

  Future<void> deletePhotoOfWorkspaceById(int imageId) async {
    var baseUrl = NetworkController().getUrl();
    Map<String, String> headers = {};
    var token = await NetworkController().getAccessToken();
    headers["Authorization"] = 'Bearer $token';
    headers["Content-type"] = 'application/json; charset=utf-8';
    headers["Accept"] = "application/json";
    var fields = <String, dynamic>{};
    var uri = Uri.http(baseUrl, '/api/workspacesPhoto/$imageId');
    final response = await http.delete(uri, headers: headers,);
    if (response.statusCode == 200) {
      print("successful delete workspaces photo!");
    } else if (response.statusCode == 401) {
      /// Обновление access токена
      await NetworkController().updateAccessToken();
      return deletePhotoOfWorkspaceById(imageId);
    } else {
      print("response code: ${response.statusCode}");
      throw Exception('Error delete workspaces photo');
    }
  }
}
