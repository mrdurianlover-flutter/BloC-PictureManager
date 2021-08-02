import 'package:picts_manager/models/user.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final User user;

  Authenticated({required this.user});
}
