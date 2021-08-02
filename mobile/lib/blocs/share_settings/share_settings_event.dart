import 'package:picts_manager/models/user.dart';

abstract class ShareSettingsEvent {}

class AddUserSubmitted extends ShareSettingsEvent {
  final String username;

  AddUserSubmitted(this.username);
}

class UserDeletionSubmitted extends ShareSettingsEvent {
  final User user;

  UserDeletionSubmitted(this.user);
}

class FetchSharedUsers extends ShareSettingsEvent {}
