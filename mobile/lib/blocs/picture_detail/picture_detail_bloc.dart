import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_event.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_state.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/repositories/picture_detail_repository.dart';

class PictureDetailBloc extends Bloc<PictureDetailEvent, PictureDetailState> {
  final _pictureDetailRepo = PictureDetailRepository();

  PictureDetailBloc() : super(NotEditingState(null));

  @override
  Stream<PictureDetailState> mapEventToState(PictureDetailEvent event) async* {
    if (event is LoadingPictureDetailScreen) {
      yield NotEditingState(event.picture);
    }

    if (event is StartEditingTitleEvent) {
      yield EditingTitleState(event.picture);
    }

    if (event is DoneEditingTitleEvent) {
      try {
        await _pictureDetailRepo.editTitle(event.newTitle, event.picture.id!);
        Picture newPicture = event.picture;
        newPicture.title = event.newTitle;
        yield NotEditingState(event.picture);
      } catch (e) {
        print(e);
        yield FailToEditTitleState('Could not Edit Title');
      }
    }
    if (event is AddingTagEvent) {
      try {
        Picture newPicture = event.picture!;
        newPicture.tags.add(event.addedTag);
        await _pictureDetailRepo.addTag(newPicture.tags, newPicture.id!);
        yield NotEditingState(newPicture);
      } catch (e) {
        yield FailToAddTagState('Could not add tag');
      }
    }
    if (event is RemovingTagEvent) {
      try {
        Picture newPicture = event.picture!;
        newPicture.tags.remove(event.removedTag);
        await _pictureDetailRepo.removeTag(newPicture);
        yield NotEditingState(newPicture);
      } catch (e) {
        yield FailToAddTagState('Could not add tag');
      }
    }

    if (event is DeletingPictureEvent) {
      yield DeletingPictureState();
      try {
        _pictureDetailRepo.deletePicture(event.picture);
        yield NotEditingState(null);
        Navigator.pop(event.context);
      } catch (e) {
        FailToDeletePictureState('Fail  to delete picture');
      }
    }
/*



    if (event is RemoveTagEvent) {
      yield RemovingTagState();
      try {
        await _PictureDetailRepo.removeTag();
        yield RemovedTagState();
      } catch (e) {
        yield FailToRemoveTagState();
      }
    }*/
  }
}
