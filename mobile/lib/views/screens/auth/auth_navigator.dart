import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/views/screens/auth/login_view.dart';
import 'package:picts_manager/views/screens/auth/sign_up_view.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show login
          if (state == AuthState.login) MaterialPage(child: LoginView()),

          // Show sign up
          if (state == AuthState.signUp) MaterialPage(child: SignUpView()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
