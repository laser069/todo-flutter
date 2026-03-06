import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/todo_repositories.dart';

part 'todo_provider.g.dart';

/// Provider for the TodoRepository
/// This is an auto-generated provider by riverpod_annotation
@riverpod
TodoRepository todoRepository(Ref ref) {
  return TodoRepository();
}
