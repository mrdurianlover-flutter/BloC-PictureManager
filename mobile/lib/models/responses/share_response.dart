import 'package:picts_manager/models/user.dart';

class ShareResponse {
  List<User> users = [];

  ShareResponse.fromJson(List<dynamic> json) {
    for (int i = 0; i < json.length; i++) {
      users.add(User.fromJson(json[i]));
    }
  }
}
