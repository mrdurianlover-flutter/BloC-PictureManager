import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_event.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_state.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/repositories/share_repository.dart';

class ShareSettingsBloc extends Bloc<ShareSettingsEvent, ShareSettingsState> {
  final _shareRepository = ShareSettingsRepository();
  ShareSettingsBloc({required bool isAlbum, Picture? picture, Album? album})
      : super(ShareSettingsState(
            isAlbum: isAlbum, picture: picture, album: album));

  @override
  Stream<ShareSettingsState> mapEventToState(ShareSettingsEvent event) async* {
    if (event is FetchSharedUsers) {
      try {
        if (state.isAlbum) {
          final users =
              await _shareRepository.getSharedUsersFromAlbum(state.album!.id!);
          yield state.copyWith(users: users);
        } else {
          final users = await _shareRepository
              .getSharedUsersFromPicture(state.picture!.id!);
          yield state.copyWith(users: users);
        }
      } catch (e) {
        yield state.copyWith(status: SubmissionFailed(e));
      }
    }
    if (event is AddUserSubmitted) {
      yield state.copyWith(status: FormSubmitting());
      try {
        if (state.isAlbum) {
          await _shareRepository.addUserToAlbum(
              state.album!.id!, event.username);
          final users =
              await _shareRepository.getSharedUsersFromAlbum(state.album!.id!);
          print(users);
          yield state.copyWith(users: users);
        } else {
          await _shareRepository.addUserToPicture(
              state.picture!.id!, event.username);
          final users = await _shareRepository
              .getSharedUsersFromPicture(state.picture!.id!);
          yield state.copyWith(users: users);
        }
        yield state.copyWith(
            status: SubmissionSuccess(
                message: "Successfuly shared to ${event.username}"));
      } catch (e) {
        print(e);
        yield state.copyWith(status: SubmissionFailed(e));
      }
    }
    if (event is UserDeletionSubmitted) {
      yield state.copyWith(status: FormSubmitting());
      try {
        if (state.isAlbum) {
          await _shareRepository.deleteUserFromAlbum(
              state.album!.id!, event.user.id);
          final users =
              await _shareRepository.getSharedUsersFromAlbum(state.album!.id!);
          yield state.copyWith(users: users);
        } else {
          await _shareRepository.deleteUserFromPicture(
              state.picture!.id!, event.user.username);
          final users = await _shareRepository
              .getSharedUsersFromPicture(state.picture!.id!);
          yield state.copyWith(users: users);
        }
        yield state.copyWith(
            status: SubmissionSuccess(
                message: "Successfuly removed ${event.user.username}"));
      } catch (e) {
        print(e);
        yield state.copyWith(status: SubmissionFailed(e));
      }
    }
  }
}
