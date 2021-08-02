import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_bloc.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_event.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_state.dart';
import 'package:picts_manager/models/form_submission_status.dart';
import 'package:picts_manager/views/widgets/add_tag_chip_widget.dart';

class AddPictureScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPictureBloc, AddPictureState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: null,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: _sendButton(),
              )
            ],
          ),
          body: SafeArea(
            child:
                Container(padding: EdgeInsets.all(5.0), child: _pictureForm()),
          ),
        );
      },
    );
  }

  Widget _pictureForm() {
    return BlocListener<AddPictureBloc, AddPictureState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        } else if (formStatus is SubmissionSuccess) {
          _showSnackBar(context, "Picture has been added.");
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _nameField(),
            _picturePreview(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Tags",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _tagList(),
          ],
        ),
      ),
    );
  }

  Widget _picturePreview() {
    return BlocBuilder<AddPictureBloc, AddPictureState>(
        builder: (context, state) {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.file(state.picture),
        ),
      );
    });
  }

  Widget _nameField() {
    return BlocBuilder<AddPictureBloc, AddPictureState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Name',
          ),
          validator: (value) => state.isValidName ? null : 'Name is too short',
          onChanged: (value) => context.read<AddPictureBloc>().add(
                NameChanged(name: value),
              ),
        ),
      );
    });
  }

  Widget _tagList() {
    return BlocBuilder<AddPictureBloc, AddPictureState>(
        builder: (context, state) {
      List<Widget> chips = [];
      for (String tag in state.tags) {
        chips.add(
          Chip(
            label: Text(tag),
            onDeleted: () {
              context.read<AddPictureBloc>().add(TagRemoved(tag));
            },
          ),
        );
      }
      chips.add(AddTagChipWidget(
        onPressed: (text) {
          context.read<AddPictureBloc>().add(TagAdded(text));
        },
      ));
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(
          spacing: 10,
          children: chips,
        ),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _sendButton() {
    return BlocBuilder<AddPictureBloc, AddPictureState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    context.read<AddPictureBloc>().add(PictureSubmitted());
                  }
                },
                child: Text('SAVE'),
              ),
      );
    });
  }
}
