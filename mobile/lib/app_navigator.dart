import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/auth_cubit.dart';
import 'package:picts_manager/blocs/auth/session/session_cubit.dart';
import 'package:picts_manager/blocs/auth/session/session_state.dart';
import 'package:picts_manager/views/screens/auth/auth_navigator.dart';
import 'package:picts_manager/views/screens/bottom_tabs_navigator.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: AuthNavigator(),
              ),
            ),
          if (state is UnknownSessionState)
            MaterialPage(
                child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )),
          if (state is Authenticated)
            MaterialPage(
                child: BottomTabsNavigator(
              user: state.user,
            )),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
