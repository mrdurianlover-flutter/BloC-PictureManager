import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/repositories/gallery_repository.dart';

class GalleryCubit extends Cubit<Map<String, List<Picture>>> {
  final _galleryRepo = GalleryRepository();

  GalleryCubit() : super({});

  void getPictures() async {
    final Map<String, List<Picture>> _picturesMap =
        await _galleryRepo.getPictures();
    emit(_picturesMap);
  }
}
