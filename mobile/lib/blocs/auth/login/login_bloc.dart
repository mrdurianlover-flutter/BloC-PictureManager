import 'dart:async';
import 'package:picts_manager/utils/globals.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/blocs/auth/login/login_event.dart';
import 'package:picts_manager/blocs/auth/login/login_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc({required this.authRepo, required this.authCubit})
      : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final response = await authRepo.login(state.username, state.password);
        yield state.copyWith(formStatus: SubmissionSuccess());
        final prefs = await SharedPreferences.getInstance();
        print("user" + response.user.toString());
        prefs.setString('token', response.token);
        prefs.setString('userId', response.user.id);
        global.token = response.token;
        global.userId = response.user.id;
        global.header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${response.token}',
        };
        authCubit.launchSession(response.user);
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
