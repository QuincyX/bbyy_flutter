import 'package:dio/dio.dart';
import '../plugins/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreUser {
  static SharedPreferences _prefs;
  static String jwtToken;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    String _jwtToken = _prefs.getString("jwtToken");
    if (_jwtToken == null) {
      print("handle get new token");
      var r = await loginAsVisitor();
      print(">>>>>> set global token by visitor login =====> ${r.toString()}");
      _prefs.setString("jwtToken", r);
    }
    jwtToken = _jwtToken;
  }

  static setJwtToken(String newJwtToken) async {
    if (newJwtToken != null) {
      print(">>>>>> set global token by response =====> $newJwtToken");
      jwtToken = newJwtToken;
    }
  }
}

loginAsVisitor() async {
  Response response = await $http.post("user-service/user/v1/visitor/token/");
  return response.data["data"]["visitorToken"];
}
