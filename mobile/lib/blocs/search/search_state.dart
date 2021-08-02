import 'package:picts_manager/models/picture.dart';

class SearchState {
  final String? text;
  SearchState({this.text});

  SearchState copyWith({
    String? text,
  }) {
    return SearchState(text: text);
  }
}

class PictureSearchSuccess extends SearchState {
  final List<Picture> pictures;
  PictureSearchSuccess(this.pictures);
}

class PictureSearchEmpty extends SearchState {}

class PictureSearchFailed extends SearchState {}

class SearchTextFieldEmpty extends SearchState {}
