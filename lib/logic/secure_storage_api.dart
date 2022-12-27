import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorage {
  SecurityStorage._internal();
  static final SecurityStorage _singleton = SecurityStorage._internal();
  factory SecurityStorage() {
    return _singleton;
  }
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> saveValueStorage(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String> getValueStorage(String key) async {
    return await secureStorage.read(key: key) ?? "";
  }

  Future<bool> storageIsNotEmpty() async {
    Map<String, String> allValues = await secureStorage.readAll();
    if (allValues.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> clearValueStorage() async {
    if (await storageIsNotEmpty()) {
      await secureStorage.deleteAll();
    } else {
      return;
    }
  }

/////////////////////////////////////
  Future<void> saveAccessTokenStorage(String accessToken) async {
    _accessToken = accessToken;///так делать нельзя, но приходится
    await saveValueStorage('accessToken', accessToken);
  }

  Future<void> saveRefreshTokenStorage(String refreshToken) async {
    await saveValueStorage('refreshToken', refreshToken);
  }

  Future<void> saveIdStorage(int id) async {
    await saveValueStorage('id', id.toString());
  }

  Future<void> saveTypeStorage(String type) async {
    await saveValueStorage('type', type);
  }

  Future<void> saveLoginStorage(String login) async {
    await saveValueStorage('login', login);
  }

  Future<bool> hasJWTTokensStorage() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var refreshToken = await secureStorage.read(key: 'refreshToken');
    return accessToken != null || refreshToken != null;
  }

  Future<bool> hasEmailStorage() async {
    var value = secureStorage.read(key: 'email');
    return value != null;
  }

  Future<String> getAccessTokenStorage() async {
    return await getValueStorage('accessToken');
  }

  Future<String> getRefreshTokenStorage() async {
    return await getValueStorage('refreshToken');
  }

  Future<int> getIdStorage() async {
    String str = await getValueStorage('id');
    return int.parse(str);
  }

  Future<String> getTypeStorage() async {
    _userTypeMemorized = await getValueStorage('type');
    return _userTypeMemorized;
  }

  Future<String> getLoginStorage() async {
    return await secureStorage.read(key: 'login') ?? '';
  }

  Future<void> deleteAllStorage() async {
    return secureStorage.deleteAll();
  }
  String _accessToken = '';
  String getAccessTokenStorageCYNC() {
    return _accessToken;
  }
  String _userTypeMemorized = '';
  String getLastUserTypeCYNC(){
    return _userTypeMemorized;
  }
}
