import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/gallery/gallery_cubit.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/views/widgets/image_list_widget.dart';
import 'package:picts_manager/views/widgets/title_widget.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, Map<String, List<Picture>>>(
      builder: (context, pictures) {
        if (pictures.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleWidget('Photos'),
              TabBar(
                  labelPadding: EdgeInsets.all(10),
                  labelStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal), //For Selected tab
                  tabs: [
                    Text('My Pictures'),
                    Text('Shared Pictures'),
                  ]),
              Flexible(
                child: TabBarView(children: [
                  RefreshIndicator(
                    child: ImageListWidget(pictures["myPictures"]!),
                    onRefresh: () async =>
                        BlocProvider.of<GalleryCubit>(context).getPictures(),
                  ),
                  RefreshIndicator(
                    child: ImageListWidget(pictures["sharedPictures"]!),
                    onRefresh: () async =>
                        BlocProvider.of<GalleryCubit>(context).getPictures(),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
