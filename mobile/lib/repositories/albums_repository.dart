import 'dart:convert';

import 'package:picts_manager/api/api_base_helper.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/models/responses/albums_response.dart';
import 'package:picts_manager/utils/generate_header.dart';

class AlbumsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Map<String, List<Album>>> getAlbums() async {
    final response = await _helper.get('/gallery/getByOwner',
        headers: await getBearedHeader());
    return AlbumsResponse.fromJson(response['body']!).albums;
  }

  Future<List<Picture>> getPictureFromAlbum({required albumId}) async {
    final response = await _helper.get('/picture/getByAlbum/$albumId',
        headers: await getBearedHeader());
    return AlbumsResponse.fromList(response['body']).pictures;
  }

  Future<Album> addAlbum(String albumName) async {
    final response = await _helper.post('/gallery/createGallery',
        body: jsonEncode({"galleryname": albumName}),
        headers: await getBearedHeader());
    return Album.fromJson(response['body']);
  }

  Future<void> deleteAlbum(String albumId) async {
    await _helper.delete('/gallery/$albumId', headers: await getBearedHeader());
  }

  Future<void> changeAlbumName(String albumId, String newAlbumName) async {
    await _helper.put('/gallery/update',
        jsonEncode({"galleryname": newAlbumName, "album_id": albumId}),
        headers: await getBearedHeader());
  }

  Future<List<dynamic>> getAlbumsByPicture(String pictureId) async {
    Map<String, dynamic> response = await _helper.post('/picture/listgallery',
        body: jsonEncode({"picture_id": pictureId}),
        headers: await getBearedHeader());
    return response['body'];
  }

  Future<void> addPictureToAlbum(String pictureId, String albumId) async {
    await _helper.post(
      '/gallery/add',
      body: jsonEncode({"picture_id": pictureId, "album_id": albumId}),
      headers: await getBearedHeader(),
    );
  }

  Future<void> deletePictureFromAlbum(String pictureId, String albumId) async {
    await _helper.delete(
      '/gallery/$albumId/$pictureId',
      headers: await getBearedHeader(),
    );
  }
}
