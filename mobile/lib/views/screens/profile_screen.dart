import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/auth/session/session_cubit.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String? username;

  const ProfileScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $username'),
            TextButton(
              child: Text('sign out'),
              onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}
