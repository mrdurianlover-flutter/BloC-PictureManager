import 'package:picts_manager/api/api_base_helper.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/models/responses/gallery_response.dart';
import 'package:picts_manager/models/responses/search_response.dart';
import 'package:picts_manager/utils/generate_header.dart';

class GalleryRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Map<String, List<Picture>>> getPictures() async {
    final response =
        await _helper.get('/picture', headers: await getBearedHeader());

    print(response);
    return GalleryResponse.fromJson(response['body']).pictures;
  }

  Future<List<Picture>> getPicturesByText(String text) async {
    final response = await _helper.get('/picture/search/$text',
        headers: await getBearedHeader());
    return SearchResponse.fromJson(response['body']).pictures;
  }
}
