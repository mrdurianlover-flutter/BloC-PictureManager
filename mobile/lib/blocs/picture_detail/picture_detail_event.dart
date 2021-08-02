import 'package:flutter/cupertino.dart';
import 'package:picts_manager/models/picture.dart';

abstract class PictureDetailEvent {}

class LoadingPictureDetailScreen extends PictureDetailEvent {
  final Picture picture;
  LoadingPictureDetailScreen(this.picture);
}

class StartEditingTitleEvent extends PictureDetailEvent {
  final Picture picture;
  StartEditingTitleEvent(this.picture);
}

class DoneEditingTitleEvent extends PictureDetailEvent {
  final Picture picture;
  final String newTitle;
  DoneEditingTitleEvent(this.picture, this.newTitle);
}

class AddingTagEvent extends PictureDetailEvent {
  final String addedTag;
  final Picture? picture;
  AddingTagEvent(this.addedTag, this.picture);
}

class RemovingTagEvent extends PictureDetailEvent {
  final String removedTag;
  final Picture? picture;
  RemovingTagEvent(this.removedTag, this.picture);
}

class DeletingPictureEvent extends PictureDetailEvent {
  final Picture picture;
  final BuildContext context;
  DeletingPictureEvent(this.context, this.picture);
}
