class Todo {
  String? id;
  String title;
  String priority;
  bool completed;
  DateTime? dueDate;

  Todo({
    this.id,
    required this.title,
    this.priority = "Medium",
    this.completed = false,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "priority": priority,
      "completed": completed,
      "dueDate": dueDate?.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map["_id"],
      title: map["title"] ?? "",
      priority: map["priority"] ?? "Medium",
      completed: map["completed"] ?? false,
      dueDate: map["dueDate"] != null
          ? DateTime.parse(map["dueDate"])
          : null,
    );
  }
}