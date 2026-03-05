import 'package:flutter/material.dart';
import '../models/todo.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? existingTodo;

  const AddTodoPage({super.key, this.existingTodo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController todoController = TextEditingController();

  String priority = "Medium";
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();

    if (widget.existingTodo != null) {
      todoController.text = widget.existingTodo!.title;
      priority = widget.existingTodo!.priority;
      dueDate = widget.existingTodo!.dueDate;
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  void saveTodo() {
    if (todoController.text.trim().isEmpty) return;

    final todo = Todo(
      title: todoController.text.trim(),
      priority: priority,
      dueDate: dueDate,
      completed: widget.existingTodo?.completed ?? false,
    );

    Navigator.pop(context, todo);
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTodo != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Task" : "Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Task Title
            TextField(
              controller: todoController,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Priority Dropdown
            DropdownButtonFormField<String>(
              initialValue: priority,
              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "High", child: Text("High")),
              ],
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Due Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    dueDate == null
                        ? "No due date selected"
                        : "Due: ${dueDate!.toLocal().toString().split(" ")[0]}",
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveTodo,
                child: Text(isEditing ? "Save Changes" : "Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
