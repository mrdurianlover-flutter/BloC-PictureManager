import 'package:flutter/cupertino.dart';
import 'package:picts_manager/utils/styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 32.0, bottom: 32),
      child: Text(
        title,
        style: Styles.titleStyle,
      ),
    );
  }
}
