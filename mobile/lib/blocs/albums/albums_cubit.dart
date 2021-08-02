import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/repositories/albums_repository.dart';

class AlbumsCubit extends Cubit<Map<String, List<Album>>> {
  final _albumsRepo = AlbumsRepository();
  Map<String, List<Album>> _albumsMap = {'myAlbums': [], 'sharedAlbums': []};

  AlbumsCubit() : super({'myAlbums': [], 'sharedAlbums': []});

  void getAlbums() async {
    _albumsMap = await _albumsRepo.getAlbums();
    emit(_albumsMap);
  }

  void addAlbum(String albumName) async {
    final Album addedAlbum = await _albumsRepo.addAlbum(albumName);
    _albumsMap['myAlbums']!.add(addedAlbum);
    Map<String, List<Album>> modifiedMap = Map.from(_albumsMap);
    emit(modifiedMap);
  }

  void deleteAlbum(String albumId, BuildContext context) async {
    await _albumsRepo.deleteAlbum(albumId);
    Navigator.pop(context);
  }
}
