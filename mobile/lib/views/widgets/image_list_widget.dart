import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/gallery/gallery_cubit.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_bloc.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_event.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/views/screens/picture_detail_screen.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class ImageListWidget extends StatelessWidget {
  final List<Picture> pictures;
  //
  ImageListWidget(this.pictures);

  @override
  Widget build(BuildContext context) {
    List<Widget> pictureWidgets = generatePictureWidgets(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: pictureWidgets,
      ),
    );
  }

  List<Widget> generatePictureWidgets(BuildContext context) {
    List<Widget> pictureWidgets = [];
    for (Picture picture in pictures) {
      pictureWidgets.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider<PictureDetailBloc>(
                          create: (BuildContext context) => PictureDetailBloc()
                            ..add(LoadingPictureDetailScreen(picture)),
                          child: PictureDetailScreen(),
                        ))).then((value) =>
                BlocProvider.of<GalleryCubit>(context).getPictures());
          },
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              picture.thumbnail!,
              headers: globals.header,
            ),
          ),
        ),
      );
    }
    return pictureWidgets;
  }
}
