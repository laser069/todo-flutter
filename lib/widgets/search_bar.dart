import 'package:flutter/material.dart';

class TodoSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const TodoSearchBar({super.key, required this.onSearch});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsetsGeometry.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hint: Text("Search tasks..."),
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.grey,
        ),
        onChanged: onSearch,
      ),
    );
  }
}
