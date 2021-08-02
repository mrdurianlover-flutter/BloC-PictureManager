import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picts_manager/blocs/search/search_bloc.dart';
import 'package:picts_manager/blocs/search/search_event.dart';
import 'package:picts_manager/blocs/search/search_state.dart';
import 'package:picts_manager/views/widgets/image_list_widget.dart';
import 'package:picts_manager/views/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:picts_manager/views/widgets/search_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SearchBloc(),
        child: Column(
          children: [_searchBar(), _picturesGrid()],
        ),
      ),
    );
  }
}

Widget _picturesGrid() {
  return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
    if (state is PictureSearchSuccess) {
      return Flexible(
        child: ImageListWidget(state.pictures),
      );
    } else if (state is PictureSearchEmpty) {
      return Expanded(
          child: Center(child: Text("There is no results for your search :(")));
    } else if (state is PictureSearchFailed) {
      return Expanded(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Ouups... Failed to retrieve the results. Check your network connection",
          textAlign: TextAlign.center,
        ),
      )));
    } else if (state is SearchTextFieldEmpty) {
      return Expanded(
          child: Center(child: Text("Search's results will appear here.")));
    }
    return PlaceholderWidget(Colors.white);
  });
}

Widget _searchBar() {
  return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
    return SearchBar(
        onChange: (value) => context.read<SearchBloc>().add(
              SearchTextChanged(text: value),
            ));
  });
}
