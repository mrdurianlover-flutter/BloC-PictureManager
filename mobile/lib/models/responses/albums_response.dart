import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/models/picture.dart';

class AlbumsResponse {
  Map<String, List<Album>> albums = {};
  List<Picture> pictures = [];

  AlbumsResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    List<Album> myAlbums = [];
    List<Album> sharedAlbums = [];

    if (json['myAlbums'] is List) {
      for (int i = 0; i < json['myAlbums'].length; i++) {
        myAlbums.add(Album.fromJson(json['myAlbums'][i]));
      }
    }
    if (json['mySharedAlbums'] != null) {
      for (int i = 0; i < json['mySharedAlbums'].length; i++) {
        sharedAlbums.add(Album.fromJson(json['mySharedAlbums'][i]));
      }
    }
    albums['myAlbums'] = myAlbums;
    albums['sharedAlbums'] = sharedAlbums;
  }

  AlbumsResponse.fromList(List<dynamic> list) {
    for (Map<String, dynamic> picture in list) {
      Picture _picture = Picture.fromJson(picture);
      pictures.add(_picture);
    }
  }
}
