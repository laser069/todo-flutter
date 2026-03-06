import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/providers/todo_controller.dart';
import '../models/todo.dart';
import '../widgets/todo_tile.dart';
import 'add_todo.dart';

/// HomePage is the main screen of the Todo application.
/// It displays a list of todos with options to add, toggle, and delete them.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: todosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add a new task',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoTile(
                todo: todo,
                onDelete: () {
                  ref
                      .read(todoControllerProvider.notifier)
                      .deleteTodo(todo.id!);
                  _showSnackBar(context, 'Task deleted');
                },
                onTap: () => _navigateToEditTodo(context, ref, todo),
                onToggle: (value) {
                  ref
                      .read(todoControllerProvider.notifier)
                      .toggleTodo(todo.id!, value ?? false);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading tasks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(todoControllerProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Navigate to the Add Todo page
  void _navigateToAddTodo(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );

    if (result != null && context.mounted) {
      ref.read(todoControllerProvider.notifier).addTodo(result);
      _showSnackBar(context, 'Task added');
    }
  }

  /// Navigate to the Edit Todo page
  void _navigateToEditTodo(
    BuildContext context,
    WidgetRef ref,
    Todo todo,
  ) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage(existingTodo: todo)),
    );

    if (result != null && context.mounted) {
      // Update the todo with new values
      ref.read(todoControllerProvider.notifier).updateTodo(todo.id!, result);
      _showSnackBar(context, 'Task updated');
    }
  }

  /// Show a snackbar message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
