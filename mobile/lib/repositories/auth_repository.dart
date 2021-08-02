import 'package:picts_manager/api/api_base_helper.dart';
import 'package:picts_manager/models/responses/login_response.dart';
import 'package:picts_manager/models/user.dart';
import 'package:picts_manager/utils/generate_header.dart';

class AuthRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginResponse> login(String username, String password) async {
    final response = await _helper.post("/user/login",
        body: {"username": username, "password": password});
    return LoginResponse.fromJson(response);
  }

  Future<String?> signUp(
      String fullname, String username, String password) async {
    await _helper.post("/user/signup", body: {
      "fullname": fullname,
      "username": username,
      "password": password
    });
    return "Success";
  }

  Future<User?> getUserById(String id) async {
    final response =
        await _helper.get("/user/$id", headers: await getBearedHeader());

    return User.fromJson(response["body"]);
  }
}
