import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_quest/backend/core/result.dart';

/// Abstract Base Repository
/// Provides common CRUD operations for all repositories
/// 
/// Type parameter T: The model/entity type this repository handles
/// 
/// Demonstrates:
/// - Repository Pattern (data access abstraction)
/// - Generic Programming (reusable for any entity)
/// - Dependency Inversion (depend on abstraction, not concrete Supabase)
abstract class BaseRepository<T> {
  /// Supabase client for database operations
  final SupabaseClient supabase;

  BaseRepository(this.supabase);

  /// Table name in Supabase database
  /// Must be implemented by concrete repositories
  String get tableName;

  /// Convert JSON map to entity type T
  /// Must be implemented by concrete repositories
  /// 
  /// Example: fromJson(json) => MissionsRow.fromJson(json)
  T fromJson(Map<String, dynamic> json);

  // ============================================================================
  // BASIC CRUD OPERATIONS
  // ============================================================================

  /// Get all records from table
  /// Returns list of entities
  /// 
  /// Optional filters can be applied in concrete implementations
  Future<Result<List<T>>> getAll();

  /// Get single record by ID
  /// Returns entity or null if not found
  /// 
  /// @param id - Primary key value
  Future<Result<T?>> getById(String id);

  /// Insert new record
  /// Returns created entity with generated fields (id, timestamps)
  /// 
  /// @param data - Map of column names to values
  Future<Result<T>> insert(Map<String, dynamic> data);

  /// Update existing record
  /// Returns updated entity
  /// 
  /// @param id - Primary key value
  /// @param data - Map of columns to update
  Future<Result<T>> update(String id, Map<String, dynamic> data);

  /// Delete record by ID
  /// Returns void on success
  /// 
  /// @param id - Primary key value
  Future<Result<void>> delete(String id);

  // ============================================================================
  // BATCH OPERATIONS
  // ============================================================================

  /// Get multiple records by IDs
  /// More efficient than multiple getById calls
  /// 
  /// @param ids - List of primary key values
  Future<Result<List<T>>> getByIds(List<String> ids);

  /// Insert multiple records in batch
  /// Returns list of created entities
  /// 
  /// @param dataList - List of data maps to insert
  Future<Result<List<T>>> insertBatch(List<Map<String, dynamic>> dataList);

  /// Update multiple records matching condition
  /// Returns number of updated records
  /// 
  /// @param condition - Where clause condition
  /// @param data - Map of columns to update
  Future<Result<int>> updateWhere(
    String condition,
    Map<String, dynamic> data,
  );

  /// Delete multiple records by IDs
  /// Returns number of deleted records
  /// 
  /// @param ids - List of primary key values
  Future<Result<int>> deleteBatch(List<String> ids);

  // ============================================================================
  // QUERY HELPERS
  // ============================================================================

  /// Count total records in table
  /// Optional where clause for filtered count
  Future<Result<int>> count([String? whereClause]);

  /// Check if record exists by ID
  /// More efficient than getById when only checking existence
  Future<Result<bool>> exists(String id);

  /// Get records with pagination
  /// 
  /// @param page - Page number (1-indexed)
  /// @param pageSize - Number of records per page
  Future<Result<List<T>>> paginate({
    required int page,
    required int pageSize,
  });

  /// Get records with custom filter
  /// Allows complex queries beyond simple ID lookup
  /// 
  /// @param column - Column name to filter on
  /// @param operator - Comparison operator (eq, neq, gt, lt, etc.)
  /// @param value - Value to compare against
  Future<Result<List<T>>> filter({
    required String column,
    required String operator,
    required dynamic value,
  });

  /// Get records ordered by column
  /// 
  /// @param column - Column name to sort by
  /// @param ascending - Sort direction (true = ASC, false = DESC)
  Future<Result<List<T>>> orderBy({
    required String column,
    bool ascending = true,
  });

  // ============================================================================
  // TRANSACTION SUPPORT
  // ============================================================================

  /// Execute multiple operations in transaction
  /// All operations succeed or all fail together
  /// 
  /// @param operations - List of database operations to execute
  Future<Result<void>> transaction(
    List<Future<Result<dynamic>>> operations,
  );

  // ============================================================================
  // SEARCH OPERATIONS
  // ============================================================================

  /// Search records by text query
  /// Performs full-text search on specified columns
  /// 
  /// @param query - Search query string
  /// @param columns - Columns to search in
  Future<Result<List<T>>> search({
    required String query,
    required List<String> columns,
  });

  /// Get records matching multiple conditions (AND logic)
  /// 
  /// @param conditions - Map of column to value conditions
  Future<Result<List<T>>> findWhere(Map<String, dynamic> conditions);

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Refresh/reload record by ID
  /// Fetches latest data from database
  Future<Result<T?>> refresh(String id);

  /// Upsert (insert or update)
  /// Inserts if not exists, updates if exists
  /// 
  /// @param data - Data map with id field
  Future<Result<T>> upsert(Map<String, dynamic> data);

  /// Soft delete (mark as deleted without removing)
  /// Sets archived/deleted flag instead of deleting row
  /// 
  /// @param id - Primary key value
  Future<Result<T>> softDelete(String id);

  // ============================================================================
  // ERROR HANDLING
  // ============================================================================

  /// Handle Supabase errors and convert to Result
  /// Standardizes error handling across repositories
  /// 
  /// @param error - Exception caught from Supabase
  Result<T> handleError<T>(Object error);

  /// Validate data before insert/update
  /// Override in concrete repositories for custom validation
  /// 
  /// @param data - Data to validate
  /// Returns validation errors or empty list if valid
  List<String> validate(Map<String, dynamic> data);
}
