import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/repositories/albums_repository.dart';

abstract class AlbumDetailEvent {}

class LoadingAlbumDetailScreen extends AlbumDetailEvent {
  final Album album;
  LoadingAlbumDetailScreen(this.album);
}

class EditingAlbumNameEvent extends AlbumDetailEvent {
  final Album album;
  final String newAlbumName;
  EditingAlbumNameEvent(this.album, this.newAlbumName);
}

abstract class AlbumDetailState {}

class AlbumDetailInitialState extends AlbumDetailState {}

class AlbumDetailLoadingState extends AlbumDetailState {}

class EditingAlbumNameState extends AlbumDetailState {}

class AlbumDetailLoadedState extends AlbumDetailState {
  List<Picture> pictures;
  Album album;
  AlbumDetailLoadedState(this.pictures, this.album);
}

class AlbumDetailFailedState extends AlbumDetailState {
  String errorMessage;
  AlbumDetailFailedState(this.errorMessage);
}

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final _albumRepo = AlbumsRepository();
  List<Picture> _pictures = [];
  late Album _album;

  AlbumDetailBloc() : super(AlbumDetailInitialState());

  @override
  Stream<AlbumDetailState> mapEventToState(AlbumDetailEvent event) async* {
    if (event is LoadingAlbumDetailScreen) {
      _album = event.album;
      yield AlbumDetailLoadingState();
      try {
        _pictures =
            await _albumRepo.getPictureFromAlbum(albumId: event.album.id);
        yield AlbumDetailLoadedState(_pictures, _album);
      } catch (e) {
        yield AlbumDetailFailedState('could not get Picture from this album');
      }
    }

    if (event is EditingAlbumNameEvent) {
      yield EditingAlbumNameState();
      try {
        await _albumRepo.changeAlbumName(event.album.id!, event.newAlbumName);
        Album newAlbum =
            Album(event.album.id!, event.newAlbumName, event.album.owner);
        yield AlbumDetailLoadedState(_pictures, newAlbum);
      } catch (e) {
        yield AlbumDetailFailedState('Could not rename Album');
      }
    }
  }
}
