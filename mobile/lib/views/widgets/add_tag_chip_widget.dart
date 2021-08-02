import 'package:flutter/material.dart';

class AddTagChipWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  final Function onPressed;
  AddTagChipWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Chip(
          avatar: Icon(
            Icons.add,
          ),
          label: Text("Add new tag")),
      onTap: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                child: ListTile(
                  title: TextField(
                    maxLength: 25,
                    controller: _controller,
                  ),
                  trailing: ElevatedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        this.onPressed(_controller.text);
                        Navigator.pop(context);
                      }),
                ),
              );
            })
      },
    );
  }
}
