import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/priority_colors.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Function(bool?) onToggle;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: todo.completed,
          onChanged: onToggle,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration:
                todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Priority: ${todo.priority}",
              style: TextStyle(
                color: getPriorityColor(todo.priority),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (todo.dueDate != null)
              Text(
                "Due: ${todo.dueDate!.toLocal().toString().split(" ")[0]}",
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}