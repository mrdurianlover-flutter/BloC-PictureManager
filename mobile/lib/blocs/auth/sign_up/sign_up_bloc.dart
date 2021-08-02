import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/blocs/auth/sign_up/sign_up_event.dart';
import 'package:picts_manager/blocs/auth/sign_up/sign_up_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/repositories/auth_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  SignUpBloc({required this.authRepo, required this.authCubit})
      : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    // Fullname updated
    if (event is SignUpFullnameChanged) {
      yield state.copyWith(fullname: event.fullname);
      // Username updated
    } else if (event is SignUpUsernameChanged) {
      yield state.copyWith(username: event.username);

      // Password sumbitted
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.signUp(state.fullname, state.username, state.password);
        yield state.copyWith(formStatus: SubmissionSuccess());
        authCubit.showLogin();
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
