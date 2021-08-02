import 'dart:io';

import 'package:picts_manager/models/form_submission_status.dart';

class AddPictureState {
  final String name;
  bool get isValidName => name.length > 0;
  final File picture;
  final List<String> tags;
  final FormSubmissionStatus formStatus;

  AddPictureState(
      {required this.picture,
      this.name = '',
      this.formStatus = const InitialFormStatus(),
      this.tags = const []});

  AddPictureState copyWith({
    String? name,
    List<String>? tags,
    File? picture,
    FormSubmissionStatus? formStatus,
  }) {
    return AddPictureState(
        picture: picture ?? this.picture,
        name: name ?? this.name,
        tags: tags ?? this.tags,
        formStatus: formStatus ?? this.formStatus);
  }
}
