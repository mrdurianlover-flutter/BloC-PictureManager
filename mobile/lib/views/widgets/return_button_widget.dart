import 'package:flutter/material.dart';
import 'package:picts_manager/utils/styles.dart';

class ReturnButton extends StatelessWidget {
  final BuildContext context;

  ReturnButton(this.context);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: Styles.returnButtonStyle,
      child: Row(
        children: [
          Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 50.0,
          ),
          Text('BACK TO GALLERY'),
        ],
      ),
    );
  }
}
