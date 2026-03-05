import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoApi {
  static const String baseUrl = "http://172.23.208.1:3000/api";

  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse("$baseUrl/todos/all"));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded["todos"];
      // return data.map((item) => Todo.fromMap(item));
      return data.map((item) => Todo.fromMap(item)).toList();
    } else {
      print("sdfkpsndfpo");
      print(response.statusCode.toString());

      throw Exception("Failed to load todos");
    }
  }

  static Future<void> createTodo(Todo todo) async {
    await http.post(
      Uri.parse("$baseUrl/todos/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toMap()),
    );
  }

  static Future<void> updateTodo(String id, Todo todo) async {
    await http.put(
      Uri.parse("$baseUrl/todos/update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toMap()),
    );
  }

  static Future<Todo> fetchTodo(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/todos/$id"));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final Todo todo = Todo.fromMap(decoded["todo"]);
      return todo;
    } else {
      throw Exception("Failed to fetch");
    }
  }

  static Future<void> deleteTodo(String id) async {
    await http.delete(Uri.parse("$baseUrl/todos/delete/$id"));
  }
}
