
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';

class SharedPrefService {

  static SharedPrefService _instance = new SharedPrefService.internal();
  SharedPrefService.internal();
  factory SharedPrefService() => _instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //DEVICE TOKEN
  Future<String> getDeviceToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstant.kDeviceToken) ?? '';
  }

  Future<bool> saveDeviceToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstant.kDeviceToken, token);
  }

  //USER CREDENTIAL
  Future<String> getUserEmail() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.get(AppConstant.kEmail) ?? '';
  }

  Future<String> getUserPassword() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.get(AppConstant.kPassword) ?? '';
  }

  Future<bool> saveUserEmail(String email) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstant.kEmail, email);
  }

  Future<bool> saveUserPassword(String password) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstant.kPassword, password);
  }

}