import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/album_detail/album_detail_bloc.dart';
import 'package:picts_manager/blocs/albums/albums_cubit.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/views/screens/album_detail_screen.dart';

class AlbumListWidget extends StatelessWidget {
  final BuildContext albumScreenContext;
  final List<Album> albums;
  final bool isMyAlbum;
  final TextEditingController _controller = TextEditingController();
  AlbumListWidget(this.albums, this.isMyAlbum, this.albumScreenContext);

  @override
  Widget build(BuildContext context) {
    List<Widget> albumWidgets =
        generateAlbumWidgets(context, albumScreenContext);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: albumWidgets,
      ),
    );
  }

  List<Widget> generateAlbumWidgets(BuildContext context, albumScreenContext) {
    List<Widget> albumWidgets = [];
    for (Album album in albums) {
      albumWidgets.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<AlbumDetailBloc>(
                  create: (BuildContext context) =>
                      AlbumDetailBloc()..add(LoadingAlbumDetailScreen(album)),
                  child: AlbumDetailScreen(album, albumScreenContext),
                ),
              ),
            ).then((value) {
              BlocProvider.of<AlbumsCubit>(context).getAlbums();
            });
          },
          child: Card(
            child: Center(
              child: Text(
                album.name!,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
    if (isMyAlbum) {
      albumWidgets.add(
        GestureDetector(
          onTap: () {
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
                        controller: _controller,
                      ),
                      trailing: ElevatedButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            BlocProvider.of<AlbumsCubit>(albumScreenContext)
                                .addAlbum(_controller.text);
                            Navigator.pop(context);
                          }),
                    ),
                  );
                });
          },
          child: Card(
            child: Center(
                child: Icon(
              Icons.add,
              size: 50.0,
              color: Colors.blue,
            )),
          ),
        ),
      );
    }
    return albumWidgets;
  }
}
