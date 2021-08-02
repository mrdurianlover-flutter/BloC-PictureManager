import 'package:picts_manager/blocs/albums/albums_cubit.dart';
import 'package:picts_manager/models/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/views/widgets/album_list_widget.dart';
import 'package:picts_manager/views/widgets/title_widget.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumsCubit, Map<String, List<Album>>>(
      builder: (context, albums) {
        if (albums.isEmpty) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleWidget('Albums'),
              TabBar(
                  labelPadding: EdgeInsets.all(10),
                  labelStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal), //For Selected tab
                  tabs: [
                    Text('My Albums'),
                    Text('Shared Albums'),
                  ]),
              Flexible(
                child: TabBarView(children: [
                  RefreshIndicator(
                    child: AlbumListWidget(albums['myAlbums']!, true, context),
                    onRefresh: () async =>
                        BlocProvider.of<AlbumsCubit>(context).getAlbums(),
                  ),
                  RefreshIndicator(
                    child: AlbumListWidget(
                        albums['sharedAlbums']!, false, context),
                    onRefresh: () async =>
                        BlocProvider.of<AlbumsCubit>(context).getAlbums(),
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
