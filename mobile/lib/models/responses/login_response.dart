import 'package:picts_manager/models/user.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class LoginResponse {
  late String token;
  late User user;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      token = json['body']['token'];
      globals.token = token;
      user = User.fromJson(json['body']['user']);
    }
  }
}
