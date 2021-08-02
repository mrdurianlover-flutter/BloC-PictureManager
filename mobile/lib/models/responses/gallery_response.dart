import 'package:picts_manager/models/picture.dart';

class GalleryResponse {
  Map<String, List<Picture>> pictures = {};

  GalleryResponse.fromJson(Map<String, dynamic> json) {
    List<Picture> myPictures = [];
    List<Picture> sharedPictures = [];

    if (json['myPictures'] != null) {
      for (int i = 0; i < json['myPictures'].length; i++) {
        myPictures.add(Picture.fromJson(json['myPictures'][i]));
      }
    }
    if (json['sharedPictures'] != null) {
      for (int i = 0; i < json['sharedPictures'].length; i++) {
        sharedPictures.add(Picture.fromJson(json['sharedPictures'][i]));
      }
    }
    pictures['myPictures'] = myPictures;
    pictures['sharedPictures'] = sharedPictures;
  }
}
