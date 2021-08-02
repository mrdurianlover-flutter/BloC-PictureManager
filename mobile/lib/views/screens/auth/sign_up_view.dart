import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/blocs/auth/sign_up/sign_up_bloc.dart';
import 'package:picts_manager/blocs/auth/sign_up/sign_up_event.dart';
import 'package:picts_manager/blocs/auth/sign_up/sign_up_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/repositories/auth_repository.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
            authRepo: context.read<AuthRepository>(),
            authCubit: context.read<AuthCubit>()),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [_signUpForm(), _loginButton()],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (p, c) => p.formStatus != c.formStatus,
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString(), Colors.red);
          }
          if (formStatus is SubmissionSuccess) {
            _showSnackBar(
                context, "Your account have been created !", Colors.green);
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _fullnameField(),
                _usernameField(),
                _passwordField(),
                _signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget _fullnameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Full name',
        ),
        validator: (value) =>
            state.isValidFullname ? null : 'Full name is too short',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpFullnameChanged(fullname: value),
            ),
      );
    });
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username is too short',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextButton(
          onPressed: () {
            context.read<AuthCubit>().showLogin();
          },
          child: Text('Already have an account? Sign in.'),
        ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    context.read<SignUpBloc>().add(SignUpSubmitted());
                  }
                },
                child: Text('Sign up'),
              ),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
