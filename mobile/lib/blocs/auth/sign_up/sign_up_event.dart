abstract class SignUpEvent {}

class SignUpFullnameChanged extends SignUpEvent {
  final String? fullname;

  SignUpFullnameChanged({this.fullname});
}

class SignUpUsernameChanged extends SignUpEvent {
  final String? username;

  SignUpUsernameChanged({this.username});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String? password;

  SignUpPasswordChanged({this.password});
}

class SignUpSubmitted extends SignUpEvent {}
