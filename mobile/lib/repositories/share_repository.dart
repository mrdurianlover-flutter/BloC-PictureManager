import 'dart:convert';

import 'package:picts_manager/api/api_base_helper.dart';
import 'package:picts_manager/models/responses/share_response.dart';
import 'package:picts_manager/models/user.dart';
import 'package:picts_manager/utils/generate_header.dart';

class ShareSettingsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<User>> getSharedUsersFromPicture(String pictureId) async {
    final response = await _helper.get("/sharedPicture/byPicture/$pictureId",
        headers: await getBearedHeader());
    return ShareResponse.fromJson(response['body']).users;
  }

  Future<List<User>> getSharedUsersFromAlbum(String albumId) async {
    final response = await _helper.get("/gallery/getAllUsers/$albumId",
        headers: await getBearedHeader());
    print(response);
    return ShareResponse.fromJson(response['body']).users;
  }

  Future<dynamic> addUserToPicture(String pictureId, String username) async {
    final response = await _helper.put(
        "/sharedPicture/$pictureId/$username", null,
        headers: await getBearedHeader());
    print(response);
  }

  Future<dynamic> addUserToAlbum(String albumId, String username) async {
    print(albumId);
    print(username);
    final response = await _helper.post("/sharedUser/addUserToGallery",
        body: jsonEncode({"album_id": albumId, "username": username}),
        headers: await getBearedHeader());
    print(response);
  }

  Future<dynamic> deleteUserFromPicture(
      String pictureId, String username) async {
    final response = await _helper.delete("/sharedPicture/$pictureId/$username",
        headers: await getBearedHeader());
    print(response);
  }

  Future<dynamic> deleteUserFromAlbum(String albumId, String userId) async {
    final response = await _helper.delete("/sharedUser/$albumId/$userId",
        headers: await getBearedHeader());
    print(response);
  }
}
