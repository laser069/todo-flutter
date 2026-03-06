import 'package:flutter/material.dart';

/// Returns the color associated with a priority level
Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    case 'Low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
