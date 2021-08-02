import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picts_manager/blocs/add_picture/add_picture_bloc.dart';
import 'package:picts_manager/blocs/albums/albums_cubit.dart';
import 'package:picts_manager/blocs/gallery/gallery_cubit.dart';
import 'package:picts_manager/models/user.dart';
import 'package:picts_manager/views/screens/add_picture_screen.dart';
import 'package:picts_manager/views/screens/album_screen.dart';
import 'package:picts_manager/views/screens/gallery_screen.dart';
import 'package:picts_manager/views/screens/profile_screen.dart';
import 'package:picts_manager/views/screens/search_screen.dart';

class BottomTabsNavigator extends StatefulWidget {
  final User? user;
  BottomTabsNavigator({this.user});
  @override
  _BottomTabsNavigatorState createState() => _BottomTabsNavigatorState();
}

class _BottomTabsNavigatorState extends State<BottomTabsNavigator> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();

  _showPicker(ImageSource source) async {
    final image = await _picker.getImage(source: source, imageQuality: 50);

    if (image?.path != null) {
      File file;
      if (Platform.isIOS) {
        file = await FlutterExifRotation.rotateAndSaveImage(path: image!.path);
      } else {
        file = File(image!.path);
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider<AddPictureBloc>(
                    create: (BuildContext context) =>
                        AddPictureBloc(picture: file),
                    child: AddPictureScreen(),
                  )));
    }
  }

  void _showBottomModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _showPicker(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _showPicker(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions() => <Widget>[
          BlocProvider<GalleryCubit>(
            create: (BuildContext context) => GalleryCubit()..getPictures(),
            child: GalleryScreen(),
          ),
          BlocProvider<AlbumsCubit>(
            create: (BuildContext context) => AlbumsCubit()..getAlbums(),
            child: AlbumScreen(),
          ),
          SearchScreen(),
          ProfileScreen(username: widget.user?.fullname),
        ];
    List<Widget> _children = _widgetOptions();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: _children[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Albums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomModal(context);
        },
        child: Icon(Icons.photo_camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
