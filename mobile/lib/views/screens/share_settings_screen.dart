import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_bloc.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_event.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/models/user.dart';

class ShareSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareSettingsBloc, ShareSettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Share"),
          ),
          body: BlocListener<ShareSettingsBloc, ShareSettingsState>(
            listener: (context, state) {
              final status = state.status;
              if (status is SubmissionFailed) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      status.exception.toString(),
                    ),
                    backgroundColor: Colors.red));
              }
              if (status is SubmissionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(status.message ?? "Success"),
                  backgroundColor: Colors.green,
                ));
              }
            },
            child: SafeArea(
              child: state.status is FormSubmitting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: state.users.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inviteButton(),
                              if (state.users.isNotEmpty)
                                Text("Shared Users",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16.0)
                            ],
                          );
                        } else {
                          return _userWidget(state.users[index - 1]);
                        }
                      },
                      padding: EdgeInsets.all(20.0),
                    ),
            ),
          ),
        );
      },
    );
  }

  _inviteButton() {
    return BlocBuilder<ShareSettingsBloc, ShareSettingsState>(
        builder: (context, state) {
      return TextButton(
          onPressed: () => _openDialog(context),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Row(
            children: [
              Icon(Icons.add),
              const SizedBox(width: 8.0),
              Text("Invite a person")
            ],
          ));
    });
  }

  _userWidget(User user) {
    return BlocBuilder<ShareSettingsBloc, ShareSettingsState>(
        builder: (context, state) {
      return Row(children: [
        Expanded(child: Text("${user.username} / ${user.fullname}")),
        IconButton(
            onPressed: () {
              context
                  .read<ShareSettingsBloc>()
                  .add(UserDeletionSubmitted(user));
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            )),
      ]);
    });
  }

  _openDialog(BuildContext shareContext) {
    TextEditingController _controller = TextEditingController();

    showDialog(
        context: shareContext,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: ListTile(
              title: TextField(
                controller: _controller,
              ),
              trailing: ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    print(_controller.text);
                    shareContext
                        .read<ShareSettingsBloc>()
                        .add(AddUserSubmitted(_controller.text));
                    Navigator.pop(context);
                  }),
            ),
          );
        });
  }
}
