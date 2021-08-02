import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/album_detail/album_detail_bloc.dart';
import 'package:picts_manager/blocs/albums/albums_cubit.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_bloc.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_event.dart';
import 'package:picts_manager/models/album.dart';
import 'package:picts_manager/views/screens/share_settings_screen.dart';
import 'package:picts_manager/views/widgets/image_list_widget.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final BuildContext albumScreenContext;
  AlbumDetailScreen(this.album, this.albumScreenContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
        builder: (context, state) {
      if (state is AlbumDetailLoadedState) {
        return Scaffold(
          appBar: AppBar(title: Text(state.album.name!), actions: <Widget>[
            if (globals.userId == state.album.owner)
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: Text("Rename Album")),
                  if (state.pictures.isNotEmpty)
                    PopupMenuItem<int>(value: 1, child: Text("Share")),
                  PopupMenuItem<int>(value: 2, child: Text("Delete Album")),
                ],
                onSelected: (item) =>
                    _selectedItem(context, item, album, albumScreenContext),
              ),
          ]),
          body: ImageListWidget(state.pictures),
        );
      } else {
        return Container(child: Center(child: CircularProgressIndicator()));
      }
    });
  }

  void _selectedItem(
      BuildContext albumDetailScreenContext, item, album, albumScreenContext) {
    TextEditingController _controller = TextEditingController();
    switch (item) {
      case 0:
        showDialog(
            context: albumDetailScreenContext,
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
                        BlocProvider.of<AlbumDetailBloc>(
                                albumDetailScreenContext)
                            .add(
                                EditingAlbumNameEvent(album, _controller.text));
                        Navigator.pop(context);
                      }),
                ),
              );
            });
        break;
      case 1:
        Navigator.push(
            albumDetailScreenContext,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (BuildContext context) =>
                          ShareSettingsBloc(isAlbum: true, album: album)
                            ..add(FetchSharedUsers()),
                      child: ShareSettingsScreen(),
                    )));
        break;
      case 2:
        BlocProvider.of<AlbumsCubit>(albumScreenContext)
            .deleteAlbum(album.id, albumDetailScreenContext);
        break;
    }
  }
}
