import 'package:flutter/material.dart';
import '../models/todo.dart';

/// AddTodoPage is a form page for creating or editing a todo item.
class AddTodoPage extends StatefulWidget {
  /// Optional existing todo for editing mode
  final Todo? existingTodo;

  const AddTodoPage({super.key, this.existingTodo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  String _priority = 'Medium';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();

    if (widget.existingTodo != null) {
      _titleController.text = widget.existingTodo!.title;
      _priority = widget.existingTodo!.priority;
      _dueDate = widget.existingTodo!.dueDate;
    }
  }

  /// Open date picker to select due date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  /// Save the todo and return to previous screen
  void _saveTodo() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final todo = Todo(
      title: _titleController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
      completed: widget.existingTodo?.completed ?? false,
    );

    Navigator.pop(context, todo);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTodo != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Task Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter your task',
                prefixIcon: Icon(Icons.task),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 24),

            /// Priority Dropdown
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Low',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text('Low'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Row(
                    children: [
                      Icon(Icons.remove, color: Colors.orange, size: 18),
                      SizedBox(width: 8),
                      Text('Medium'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'High',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('High'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            /// Due Date Picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Due Date',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dueDate == null
                                ? 'No due date selected'
                                : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                            style: TextStyle(
                              color: _dueDate == null ? Colors.grey : null,
                            ),
                          ),
                        ),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _dueDate = null;
                              });
                            },
                          ),
                        ElevatedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.date_range),
                          label: Text(
                            _dueDate == null ? 'Pick Date' : 'Change',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// Save Button
            FilledButton.icon(
              onPressed: _saveTodo,
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save Changes' : 'Add Task'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
