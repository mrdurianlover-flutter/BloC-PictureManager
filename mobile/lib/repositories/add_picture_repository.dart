import 'package:picts_manager/api/api_base_helper.dart';

class AddPictureRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<dynamic> sendPicture(String filePath, String name, String tags) async {
    return await _helper
        .postFile("/picture", filePath, {"name": name, "tags": tags});
  }
}
