import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_event.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/repositories/add_picture_repository.dart';

class AddPictureBloc extends Bloc<AddPictureEvent, AddPictureState> {
  final _addPictureRepository = AddPictureRepository();

  AddPictureBloc({required File picture})
      : super(AddPictureState(picture: picture));

  @override
  Stream<AddPictureState> mapEventToState(AddPictureEvent event) async* {
    if (event is NameChanged) {
      yield state.copyWith(name: event.name);
    }
    if (event is TagAdded) {
      List<String> tags = List.from(state.tags);
      tags.add(event.tag);
      print(tags);
      yield state.copyWith(tags: tags);
    }
    if (event is TagRemoved) {
      List<String> tags = List.from(state.tags);
      tags.remove(event.tag);
      yield state.copyWith(tags: tags);
    }
    if (event is PictureSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await _addPictureRepository.sendPicture(
            state.picture.path, state.name, state.tags.join(","));
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
