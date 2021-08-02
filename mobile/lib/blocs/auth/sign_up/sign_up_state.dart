import 'package:picts_manager/models/form_submission_status.dart';

class SignUpState {
  final String fullname;
  bool get isValidFullname => fullname.length > 0;

  final String username;
  bool get isValidUsername => username.length > 0;

  final String password;
  bool get isValidPassword => password.length > 0;

  final FormSubmissionStatus formStatus;

  SignUpState({
    this.fullname = '',
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? fullname,
    String? username,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
