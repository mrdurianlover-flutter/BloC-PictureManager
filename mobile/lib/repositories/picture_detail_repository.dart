import 'dart:convert';

import 'package:picts_manager/api/api_base_helper.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/utils/generate_header.dart';

class PictureDetailRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> editTitle(String newTitle, String pictureId) async {
    await _helper.put("/picture/$pictureId", jsonEncode({"name": newTitle}),
        headers: await getBearedHeader());
  }

  // Future<void> editDate() async {
  //   print('Date Changed');
  //   // API CALL WITH PUT METHOD TO CHANGE Date OF THE PICTURE
  // }

  Future<void> addTag(List<String> tags, String pictureId) async {
    await _helper.put(
        "/picture/$pictureId", jsonEncode({"tags": tags.join(',')}),
        headers: await getBearedHeader());
  }

  Future<void> removeTag(Picture picture) async {
    String tags = picture.tags.join(',');
    if (tags.isEmpty) {
      tags = "EMPTY_TAG";
    }
    await _helper.put("/picture/${picture.id}", jsonEncode({"tags": tags}),
        headers: await getBearedHeader());
  }

  Future<void> deletePicture(Picture picture) async {
    print('called delete picture from repo');
    await _helper.delete("/picture/${picture.id}",
        headers: await getBearedHeader());
  }
}
