import 'package:picts_manager/models/picture.dart';

class PictureDetailState {
  Picture? picture;
  PictureDetailState(this.picture);
}

class NotEditingState extends PictureDetailState {
  final Picture? picture;
  NotEditingState(this.picture) : super(picture) {
    if (picture != null) {
      print(picture!.tags);
    }
  }
}

class EditingTitleState extends PictureDetailState {
  final Picture? picture;
  EditingTitleState(this.picture) : super(picture);
}

class FailToEditTitleState extends PictureDetailState {
  final String errorMessage;
  FailToEditTitleState(this.errorMessage) : super(null);
}

class AddingTagState extends PictureDetailState {
  AddingTagState() : super(null);
}

// class AddedTagState extends PictureDetailState {}

class FailToAddTagState extends PictureDetailState {
  final String errorMessage;
  FailToAddTagState(this.errorMessage) : super(null);
}

class RemovingTagState extends PictureDetailState {
  RemovingTagState() : super(null);
}

class FailToRemoveTagState extends PictureDetailState {
  final String errorMessage;
  FailToRemoveTagState(this.errorMessage) : super(null);
}

class DeletingPictureState extends PictureDetailState {
  DeletingPictureState() : super(null);
}

class FailToDeletePictureState extends PictureDetailState {
  final String errorMessage;
  FailToDeletePictureState(this.errorMessage) : super(null);
}

// class RemovedTagState extends PictureDetailState {}
