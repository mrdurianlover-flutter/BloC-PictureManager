import 'package:picts_manager/models/picture.dart';

class SearchResponse {
  List<Picture> pictures = [];

  SearchResponse.fromJson(List<dynamic> json) {
    for (int i = 0; i < json.length; i++) {
      pictures.add(Picture.fromJson(json[i]));
    }
  }
}
