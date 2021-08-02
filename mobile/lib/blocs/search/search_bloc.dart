import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/search/search_event.dart';
import 'package:picts_manager/blocs/search/search_state.dart';
import 'package:picts_manager/models/picture.dart';
import 'package:picts_manager/repositories/gallery_repository.dart';
import 'package:rxdart/rxdart.dart';
// class SearchCubit extends Cubit<List<Picture>> {
//

//   SearchCubit() : super([]);

//   void getPicturesByText(String text) async =>
//       emit(await _galleryRepo.getPicturesByText(text));
// }
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _galleryRepo = GalleryRepository();
  SearchBloc() : super(SearchState());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      TransitionFunction<SearchEvent, SearchState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  SearchState _handleSearchResults(List<Picture> pictures) {
    if (pictures.length > 0) {
      return PictureSearchSuccess(pictures);
    } else {
      return PictureSearchEmpty();
    }
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchTextChanged) {
      yield state.copyWith(text: event.text);
      try {
        if (state.text != '') {
          final pictures = await _galleryRepo.getPicturesByText(event.text!);
          yield _handleSearchResults(pictures);
        } else {
          yield SearchTextFieldEmpty();
        }
      } catch (e) {
        print(e);
        yield PictureSearchFailed();
      }
    }
  }
}
