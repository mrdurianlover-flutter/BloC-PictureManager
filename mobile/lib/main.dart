import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/app_navigator.dart';
import 'package:picts_manager/blocs/auth/session/session_cubit.dart';
import 'package:picts_manager/repositories/auth_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme:
          ThemeData(brightness: Brightness.dark, accentColor: Colors.blue),
      themeMode: ThemeMode.dark,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SessionCubit(
                authRepo: context.read<AuthRepository>(),
              ),
            ),
          ],
          child: AppNavigator(),
        ),
      ),
    );
  }
}
