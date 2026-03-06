import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/todo.dart';

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// TodoApi provides static methods to interact with the backend API.
class TodoApi {
  // Base URL for the API - dynamically determined based on platform
  // For Android emulator: use 10.0.2.2
  // For iOS simulator: use localhost (127.0.0.1)
  // For physical devices: use actual server IP address
  static String get baseUrl {
    const port = '3000';
    const apiPath = '/api';

    // Check if custom API URL is provided via environment
    const customUrl = String.fromEnvironment('API_URL', defaultValue: '');
    if (customUrl.isNotEmpty) {
      return '$customUrl$apiPath';
    }

    // Determine localhost based on platform
    // Android emulator uses 10.0.2.2 to reach host's localhost
    // iOS simulator uses 127.0.0.1 or localhost
    String localhost;
    if (Platform.isAndroid) {
      localhost = 'http://10.0.2.2:$port';
    } else if (Platform.isIOS) {
      localhost = 'http://127.0.0.1:$port';
    } else {
      localhost = 'http://localhost:$port';
    }

    return '$localhost$apiPath';
  }

  /// Fetch all todos from the server
  ///
  /// Returns a list of [Todo] objects on success
  /// Throws [ApiException] on failure
  static Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos/all'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['todos'];
        return data.map((item) => Todo.fromMap(item)).toList();
      } else {
        throw ApiException(
          'Failed to load todos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Create a new todo on the server
  ///
  /// [todo] - The todo to create
  /// Throws [ApiException] on failure
  static Future<void> createTodo(Todo todo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todos/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toMap()),
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Failed to create todo',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Update an existing todo on the server
  ///
  /// [id] - The ID of the todo to update
  /// [todo] - The updated todo data
  /// Throws [ApiException] on failure
  static Future<void> updateTodo(String id, Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/todos/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toMap()),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to update todo',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Fetch a single todo by its ID
  ///
  /// [id] - The ID of the todo to fetch
  /// Returns the [Todo] object on success
  /// Throws [ApiException] on failure
  static Future<Todo> fetchTodo(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return Todo.fromMap(decoded['todo']);
      } else if (response.statusCode == 404) {
        throw ApiException('Todo not found', statusCode: 404);
      } else {
        throw ApiException(
          'Failed to fetch todo',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Delete a todo from the server
  ///
  /// [id] - The ID of the todo to delete
  /// Throws [ApiException] on failure
  static Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/todos/delete/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to delete todo',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
