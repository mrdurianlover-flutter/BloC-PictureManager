import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/session/session_cubit.dart';
import 'package:picts_manager/models/user.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);

  void launchSession(User user) => sessionCubit.showSession(user);
}
