import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/session/session_state.dart';
import 'package:picts_manager/models/user.dart';
import 'package:picts_manager/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;

  SessionCubit({required this.authRepo}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");
      final token = prefs.getString("token");
      if (userId == null || token == null) {
        emit(Unauthenticated());
      } else {
        final user = await authRepo.getUserById(userId);
        if (user != null) {
          globals.token = token;
          globals.userId = userId;
          globals.header = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          };
          emit(Authenticated(user: user));
        }
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(User user) {
    emit(Authenticated(user: user));
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userId");
    await prefs.remove("token");
    globals.token = "";
    globals.userId = "";
    emit(Unauthenticated());
  }
}
