import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_tile.dart';
import '../widgets/search_bar.dart';
import 'add_todo.dart';
import '../repositories/todo_repositories.dart';

final TodoRepository repo = TodoRepository();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final data = await repo.getTodos();
    setState(() {
      todos = data;
    });
  }

  List<Todo> get filteredTodos {
    return todos
        .where((t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> addTodo(Todo todo) async {
    await repo.createTodo(todo);
    await loadTodos();
  }

  void deleteTodo(String id) {
    setState(() {
      todos.removeWhere((t) => t.id == id);
      repo.delete(id);
    });
  }

  Future<void> toggleTodo(String id, bool value) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    setState(() {
      todos[index].completed = value;
    });
    await repo.updateTodo(id, todos[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: Column(
        children: [
          TodoSearchBar(
            onSearch: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];

                return TodoTile(
                  todo: todo,
                  onDelete: () => deleteTodo(todo.id!),
                  onToggle: (value) => toggleTodo(todo.id!, value!),
                  onTap: () async {
                    final updatedTodo = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTodoPage(existingTodo: todo),
                      ),
                    );

                    if (updatedTodo != null) {
                      setState(() {
                        final actualIndex = todos.indexOf(todo);
                        todos[actualIndex] = updatedTodo;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodoPage()),
          );

          if (todo != null) addTodo(todo);
        },
      ),
    );
  }
}
