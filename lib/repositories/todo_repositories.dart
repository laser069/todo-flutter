import '../models/todo.dart';
import '../services/todo_api.dart';

/// Repository for managing todo data
/// Acts as an abstraction layer between the UI and API
class TodoRepository {
  /// Fetch all todos from the API
  Future<List<Todo>> getTodos() async {
    return await TodoApi.fetchTodos();
  }

  /// Update an existing todo
  Future<void> updateTodo(String id, Todo todo) async {
    await TodoApi.updateTodo(id, todo);
  }

  /// Fetch a single todo by ID
  Future<Todo> getTodo(String id) async {
    return await TodoApi.fetchTodo(id);
  }

  /// Create a new todo
  Future<void> createTodo(Todo todo) async {
    await TodoApi.createTodo(todo);
  }

  /// Delete a todo by ID
  Future<void> delete(String id) async {
    await TodoApi.deleteTodo(id);
  }
}
