abstract class AddPictureEvent {}

class NameChanged extends AddPictureEvent {
  final String? name;

  NameChanged({this.name});
}

class TagAdded extends AddPictureEvent {
  final String tag;

  TagAdded(this.tag);
}

class TagRemoved extends AddPictureEvent {
  final String tag;

  TagRemoved(this.tag);
}

class PictureSubmitted extends AddPictureEvent {}
