import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picts_manager/models/picture.dart';

class DateWidget extends StatelessWidget {
  final Picture? picture;

  DateWidget(this.picture);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Text(
          DateFormat.yMMMMEEEEd('en_US').add_jm().format(picture!.createdAt!),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}
