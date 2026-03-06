/// Todo model representing a task item
///
/// Properties:
/// - [id] - Unique identifier from the database
/// - [title] - Task title (required)
/// - [priority] - Priority level: 'Low', 'Medium', or 'High' (default: 'Medium')
/// - [completed] - Completion status (default: false)
/// - [dueDate] - Optional due date
class Todo {
  /// Unique identifier from the database
  String? id;

  /// Task title
  String title;

  /// Priority level: 'Low', 'Medium', or 'High'
  String priority;

  /// Completion status
  bool completed;

  /// Optional due date
  DateTime? dueDate;

  Todo({
    this.id,
    required this.title,
    this.priority = 'Medium',
    this.completed = false,
    this.dueDate,
  });

  /// Convert Todo to a Map for API requests
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priority': priority,
      'completed': completed,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Create a Todo from a Map (API response)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'],
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'Medium',
      completed: map['completed'] ?? false,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }

  /// Create a copy of this Todo with optional new values
  Todo copyWith({
    String? id,
    String? title,
    String? priority,
    bool? completed,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, priority: $priority, completed: $completed, dueDate: $dueDate)';
  }
}
