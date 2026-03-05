import '../models/todo.dart';
import '../services/todo_api.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async {
    return await TodoApi.fetchTodos();
  }

  Future<void> updateTodo(String id, Todo todo) async {
    await TodoApi.updateTodo(id, todo);
  }

  Future<Todo> getTodo(String id) async {
    return await TodoApi.fetchTodo(id);
  }

  Future<void> createTodo(Todo todo) async {
    await TodoApi.createTodo(todo);
  }

  Future<void> delete(String id) async {
    await TodoApi.deleteTodo(id);
  }
}
