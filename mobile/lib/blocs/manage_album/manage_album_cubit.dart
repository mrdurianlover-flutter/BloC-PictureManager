import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/repositories/albums_repository.dart';

class AlbumManagerCubit extends Cubit<List<dynamic>> {
  final _albumsRepo = AlbumsRepository();
  String _pictureId = "";
  List<dynamic> _albumsOfPicture = [];

  AlbumManagerCubit() : super([]);

  void getAlbumsByPicture(String pictureId) async {
    _pictureId = pictureId;
    print(_pictureId);

    _albumsOfPicture = await _albumsRepo.getAlbumsByPicture(pictureId);
    emit(_albumsOfPicture);
  }

  void addToAlbum(String albumId) async {
    print(_pictureId);
    await _albumsRepo.addPictureToAlbum(_pictureId, albumId);
    int albumIndex =
        _albumsOfPicture.indexWhere((album) => album['id'] == albumId);
    _albumsOfPicture[albumIndex]['hasPicture'] = true;

    emit(List<dynamic>.from(_albumsOfPicture));
  }

  void deleteFromAlbum(String albumId) async {
    await _albumsRepo.deletePictureFromAlbum(_pictureId, albumId);
    int albumIndex =
        _albumsOfPicture.indexWhere((album) => album['id'] == albumId);
    _albumsOfPicture[albumIndex]['hasPicture'] = false;
    emit(List<dynamic>.from(_albumsOfPicture));
  }
}
