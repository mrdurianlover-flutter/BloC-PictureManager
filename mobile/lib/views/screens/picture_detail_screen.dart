import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:picts_manager/blocs/manage_album/manage_album_cubit.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_bloc.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_event.dart';
import 'package:picts_manager/blocs/picture_detail/picture_detail_state.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_bloc.dart';
import 'package:picts_manager/blocs/share_settings/share_settings_event.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/views/screens/album_manager.dart';
import 'package:picts_manager/views/screens/share_settings_screen.dart';
import 'package:picts_manager/views/widgets/add_tag_chip_widget.dart';
import 'package:picts_manager/views/widgets/date_widget.dart';
import 'package:picts_manager/views/widgets/picture_title_widget.dart';
import 'package:picts_manager/utils/globals.dart' as globals;

class PictureDetailScreen extends StatelessWidget {
  Widget generateChip() {
    return BlocBuilder<PictureDetailBloc, PictureDetailState>(
        builder: (context, state) {
      Picture? picture;
      List<Widget> chips = [];
      if (state is NotEditingState && state.picture != null) {
        picture = state.picture;
        for (String tag in state.picture!.tags) {
          if (globals.userId == state.picture!.owner) {
            chips.add(
              Chip(
                label: Text(tag),
                onDeleted: () {
                  BlocProvider.of<PictureDetailBloc>(context)
                      .add(RemovingTagEvent(tag, picture));
                },
              ),
            );
          } else {
            chips.add(Chip(label: Text(tag)));
          }
        }
      }
      if (globals.userId == state.picture?.owner) {
        chips.add(AddTagChipWidget(
          onPressed: (text) {
            context
                .read<PictureDetailBloc>()
                .add(AddingTagEvent(text, picture));
          },
        ));
      }
      return Wrap(
        children: chips,
        spacing: 20.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = false;
    return BlocBuilder<PictureDetailBloc, PictureDetailState>(
      builder: (context, state) {
        isEditing = state is EditingTitleState ? true : false;

        if (state.picture == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: null,
            actions: <Widget>[
              IconButton(
                  onPressed: () => _showBottomModal(context, state, isEditing),
                  icon: Icon(Icons.more_horiz))
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: Container(
                color: Colors.black,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  imageProvider: CachedNetworkImageProvider(state.picture!.url!,
                      headers: globals.header),
                )
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     PictureTitle(state.picture, isEditing),
                //     Flexible(
                //       child: Image.network(
                //         state.picture!.url!,
                //         headers: globals.header,
                //       ),
                //     ),
                //     DateWidget(state.picture),
                //     Wrap(
                //       children: generateChip(state, context),
                //       spacing: 20.0,
                //     ),
                //   ],
                // ),
                ),
          ),
        );
      },
    );
  }

  void _showBottomModal(
      BuildContext context, PictureDetailState state, bool isEditing) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext contextModal) {
        final bloc = BlocProvider.of<PictureDetailBloc>(context);
        return BlocProvider.value(value: bloc, child: _bottomContainer());
      },
    );
  }

  Widget _bottomContainer() {
    return BlocBuilder<PictureDetailBloc, PictureDetailState>(
        builder: (context, state) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (state.picture?.owner == globals.userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: IconTextButton(
                          icon: Icons.post_add_sharp,
                          title: "Add/Remove Album",
                          onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            AlbumManagerCubit()
                                              ..getAlbumsByPicture(
                                                  state.picture!.id!),
                                        child: AlbumManager(),
                                      ))),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: IconTextButton(
                          icon: Icons.share,
                          title: "Share the picture",
                          onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            ShareSettingsBloc(
                                                isAlbum: false,
                                                picture: state.picture)
                                              ..add(FetchSharedUsers()),
                                        child: ShareSettingsScreen(),
                                      ))),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: IconTextButton(
                          icon: Icons.delete_forever,
                          title: "Delete the picture",
                          onPress: () {
                            Navigator.pop(context);
                            BlocProvider.of<PictureDetailBloc>(context).add(
                                DeletingPictureEvent(context, state.picture!));
                          },
                        ),
                      ),
                    ],
                  ),
                if (state.picture?.owner == globals.userId) Divider(height: 32),
                Text(
                  "NOM",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(125)),
                ),
                PictureTitle(
                  state.picture,
                  true,
                ),
                SizedBox(height: 16),
                Text(
                  "DATE",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(125)),
                ),
                DateWidget(state.picture),
                SizedBox(height: 16),
                Text(
                  "TAGS",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(125)),
                ),
                generateChip()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class IconTextButton extends StatelessWidget {
  final Function onPress;
  final String title;
  final IconData icon;
  IconTextButton(
      {required this.onPress, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPress(),
      child: Column(
        children: [
          Icon(icon),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
