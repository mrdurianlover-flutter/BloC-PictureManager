import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/models/user.dart';

class ShareSettingsState {
  final bool isAlbum;
  final Album? album;
  final Picture? picture;
  final FormSubmissionStatus status;
  final List<User> users;

  ShareSettingsState(
      {this.isAlbum = false,
      this.album,
      this.picture,
      this.status = const InitialFormStatus(),
      this.users = const []});

  ShareSettingsState copyWith(
      {bool? isAlbum,
      Album? album,
      Picture? picture,
      FormSubmissionStatus? status,
      List<User>? users}) {
    return ShareSettingsState(
        isAlbum: isAlbum ?? this.isAlbum,
        album: album ?? this.album,
        picture: picture ?? this.picture,
        status: status ?? this.status,
        users: users ?? this.users);
  }
}
