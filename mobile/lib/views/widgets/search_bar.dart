import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function onChange;
  SearchBar({required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: TextField(
            onChanged: (text) => onChange(text),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                prefixIcon: Icon(Icons.search),
                hintText: "Rechercher des photos",
                border: InputBorder.none)),
      ),
    );
  }
}
