import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_bloc.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_event.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class PictureTitle extends StatelessWidget {
  final Picture? picture;
  final bool isEditing;
  PictureTitle(this.picture, this.isEditing);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? title = "";

    if (picture != null) {
      title = picture!.title;
    }

    _controller.text = title!;
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
              enabled: picture?.owner == globals.userId,
              maxLength: 50,
              // decoration: null,
              decoration: picture?.owner == globals.userId
                  ? InputDecoration().copyWith()
                  : null,
              controller: _controller,
              showCursor: isEditing,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              onTap: () async {
                BlocProvider.of<PictureDetailBloc>(context)
                    .add(StartEditingTitleEvent(picture!));
              },
              onEditingComplete: () async {
                FocusScope.of(context).unfocus();

                BlocProvider.of<PictureDetailBloc>(context)
                    .add(DoneEditingTitleEvent(picture!, _controller.text));
              }),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: ElevatedButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => BlocProvider(
        //                       create: (BuildContext context) =>
        //                           AlbumManagerCubit()
        //                             ..getAlbumsByPicture(picture!.id!),
        //                       child: AlbumManager(),
        //                     )));
        //       },
        //       child: Text("Save")),
        // )
      ],
    );
  }
}
