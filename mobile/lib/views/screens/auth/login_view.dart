import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/blocs/auth/login/login_bloc.dart';
import 'package:picts_manager/blocs/auth/login/login_event.dart';
import 'package:picts_manager/blocs/auth/login/login_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/repositories/auth_repository.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>()),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listenWhen: (p, c) => p.formStatus != c.formStatus,
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              _showSnackBar(
                  context, formStatus.exception.toString(), Colors.red);
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [_loginForm(), _signUpButton()],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usernameField(),
              _passwordField(),
              _loginButton(),
            ],
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username is too short',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextButton(
          onPressed: () {
            context.read<AuthCubit>().showSignUp();
          },
          child: Text('Don\'t have an account? Sign up.'),
        ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                child: Text('Login'),
              ),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
