import 'package:flutter/material.dart';

class Styles {
  static TextStyle titleStyle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle returnButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.white),
    elevation: MaterialStateProperty.all(0.0),
  );
}
