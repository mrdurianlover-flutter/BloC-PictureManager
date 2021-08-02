import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getBearedHeader() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

Future<Map<String, String>> getBearedHeaderFormData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  return {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
