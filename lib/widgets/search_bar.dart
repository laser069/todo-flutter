import 'package:flutter/material.dart';

/// A search bar widget for filtering todo items
class TodoSearchBar extends StatelessWidget {
  /// Callback when search text changes
  final Function(String) onSearch;

  const TodoSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.grey,
          border: OutlineInputBorder(),
          filled: true,
        ),
        onChanged: onSearch,
      ),
    );
  }
}
