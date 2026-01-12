import 'package:uni_quest/backend/repositories/task_repository.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import '../core/result.dart';

/// Service layer for Task business logic
/// Demonstrates Facade Pattern and Business Logic separation
class TaskService {
  final TaskRepository _repository;

  static final TaskService _instance = TaskService._internal(
    TaskRepository(),
  );

  factory TaskService() => _instance;

  TaskService._internal(this._repository);

  /// Get all active tasks
  Future<Result<List<TasksRow>>> getActiveTasks() async {
    return await _repository.getActiveTasks();
  }

  /// Get all completed tasks
  Future<Result<List<TasksRow>>> getCompletedTasks() async {
    return await _repository.getCompletedTasks();
  }

  /// Get all archived tasks
  Future<Result<List<TasksRow>>> getArchivedTasks() async {
    return await _repository.getArchivedTasks();
  }

  /// Get a specific task by ID
  Future<Result<TasksRow>> getTaskById(String id) async {
    return await _repository.getById(id);
  }

  /// Create a new task
  Future<Result<TasksRow>> createTask({
    required String userId,
    required String title,
    String? description,
    DateTime? dueDate,
    String? priority,
  }) async {
    final data = {
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority ?? 'medium',
      'is_completed': false,
      'is_archived': false,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    return await _repository.create(data);
  }

  /// Toggle task completion
  Future<Result<TasksRow>> toggleTaskCompletion(
    String id,
    bool isCompleted,
  ) async {
    return await _repository.toggleComplete(id, isCompleted);
  }

  /// Update task details
  Future<Result<TasksRow>> updateTask(
    String id,
    Map<String, dynamic> updates,
  ) async {
    // Add updated_at timestamp to all updates
    final data = {...updates, 'updated_at': DateTime.now().toIso8601String()};
    return await _repository.update(id, data);
  }

  /// Archive a task
  Future<Result<TasksRow>> archiveTask(String id) async {
    return await _repository.archiveTask(id);
  }

  /// Delete a task
  Future<Result<bool>> deleteTask(String id) async {
    return await _repository.delete(id);
  }

  /// Get task statistics
  Future<Result<TaskStats>> getTaskStats() async {
    final activeResult = await _repository.getActiveTasks();
    final completedResult = await _repository.getCompletedTasks();

    if (activeResult.isFailure) {
      return Failure(activeResult.error!);
    }
    if (completedResult.isFailure) {
      return Failure(completedResult.error!);
    }

    final activeTasks = activeResult.data!;
    final completedTasks = completedResult.data!;

    // Calculate overdue tasks
    final now = DateTime.now();
    final overdueTasks = activeTasks.where((task) {
      final dueDate = task.dueDate;
      return dueDate != null && dueDate.isBefore(now);
    }).length;

    final stats = TaskStats(
      totalActive: activeTasks.length,
      totalCompleted: completedTasks.length,
      overdue: overdueTasks,
      completionRate: (completedTasks.length + activeTasks.length) > 0
          ? (completedTasks.length /
                  (completedTasks.length + activeTasks.length)) *
              100
          : 0.0,
    );

    return Success(stats);
  }

  /// Check if offline data is available
  Future<bool> hasOfflineData() async {
    return await _repository.hasCachedData();
  }

  /// Get cached tasks for offline use
  Future<Result<List<TasksRow>>> getOfflineTasks() async {
    return await _repository.getCached();
  }
}

/// Task statistics model
class TaskStats {
  final int totalActive;
  final int totalCompleted;
  final int overdue;
  final double completionRate;

  TaskStats({
    required this.totalActive,
    required this.totalCompleted,
    required this.overdue,
    required this.completionRate,
  });
}
