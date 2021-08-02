import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/manage_album/manage_album_cubit.dart';

class AlbumManager extends StatelessWidget {
  const AlbumManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumManagerCubit, List<dynamic>>(
        builder: (context, albums) {
      return Scaffold(
        appBar: AppBar(title: Text('Organize Albums')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: generateAlbumTiles(context, albums),
              ),
            )
          ],
        ),
      );
    });
  }

  List<Widget> generateAlbumTiles(BuildContext context, albums) {
    List<Widget> albumTiles = [];

    for (dynamic album in albums) {
      albumTiles.add(
        Card(
          child: ListTile(
            leading: Checkbox(
              activeColor: Colors.blue,
              value: album['hasPicture'],
              onChanged: (bool) {
                if (bool == false) {
                  BlocProvider.of<AlbumManagerCubit>(context)
                      .deleteFromAlbum(album['id']);
                } else {
                  BlocProvider.of<AlbumManagerCubit>(context)
                      .addToAlbum(album['id']);
                }
                print(album);
              },
            ),
            title: Text(album['galleryname']),
          ),
        ),
      );
    }

    return albumTiles;
  }
}
