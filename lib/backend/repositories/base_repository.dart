import 'package:uni_quest/backend/supabase/database/database.dart';
import '../core/result.dart';

/// Base repository interface following Repository Pattern
/// Demonstrates Separation of Concerns and Dependency Inversion Principle
abstract class BaseRepository<T> {
  /// Fetch all items
  Future<Result<List<T>>> getAll();

  /// Fetch single item by ID
  Future<Result<T>> getById(String id);

  /// Create new item
  Future<Result<T>> create(Map<String, dynamic> data);

  /// Update existing item
  Future<Result<T>> update(String id, Map<String, dynamic> data);

  /// Delete item
  Future<Result<bool>> delete(String id);

  /// Check if data is cached (for offline support)
  Future<bool> hasCachedData();

  /// Get cached data (for offline support)
  Future<Result<List<T>>> getCached();

  /// Clear cache
  Future<void> clearCache();
}

/// Repository implementation for database entities using Supabase
/// Follows Single Responsibility Principle - only handles data operations
abstract class SupabaseRepository<T extends SupabaseDataRow>
    implements BaseRepository<T> {
  /// Get the Supabase table instance
  SupabaseTable<T> get table;

  /// Handle errors uniformly
  Result<R> handleError<R>(dynamic error) {
    if (error is Exception) {
      return Failure(error.toString(), exception: error);
    }
    return Failure(error.toString());
  }

  /// Execute query with error handling
  Future<Result<List<T>>> executeQuery(
    Future<List<T>> Function() query,
  ) async {
    try {
      final results = await query();
      return Success(results);
    } catch (e) {
      return handleError(e);
    }
  }

  /// Execute single query with error handling
  Future<Result<T>> executeSingleQuery(
    Future<T> Function() query,
  ) async {
    try {
      final result = await query();
      return Success(result);
    } catch (e) {
      return handleError(e);
    }
  }
}
