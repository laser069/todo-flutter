import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorage {
  static const key = "todos";

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = todos.map((todo) => jsonEncode(todo.toMap())).toList();

    prefs.setStringList(key, data);
  }

  static Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key);

    if (data == null) return [];

    return data.map((e) => Todo.fromMap(jsonDecode(e))).toList();
  }
}
