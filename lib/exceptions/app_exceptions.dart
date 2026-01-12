/// Custom application exceptions for UniQuest
/// 
/// Provides domain-specific exception types for better error handling
/// and more meaningful error messages throughout the application.
/// 
/// Design Principles:
/// - Specific exception types for different failure scenarios
/// - Include error codes for localization/logging
/// - Extend base AppException for consistent handling
/// - Provide context via optional fields
/// 
/// Defense Talking Points:
/// - "Custom exceptions improve error handling specificity"
/// - "Enables better user feedback with domain-specific messages"
/// - "Facilitates error logging and debugging"
/// - "Follows Exception Hierarchy pattern"

// ============================================================================
// BASE EXCEPTION
// ============================================================================

/// Base exception for all UniQuest application errors
/// All custom exceptions should extend this class
abstract class AppException implements Exception {
  /// Human-readable error message
  final String message;
  
  /// Optional error code for categorization/logging
  final String? code;
  
  /// Optional stack trace context
  final StackTrace? stackTrace;
  
  /// Timestamp when exception occurred
  final DateTime timestamp;

  AppException(
    this.message, {
    this.code,
    this.stackTrace,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    if (code != null) {
      return 'AppException [$code]: $message';
    }
    return 'AppException: $message';
  }
}

// ============================================================================
// NETWORK & CONNECTIVITY EXCEPTIONS
// ============================================================================

/// Thrown when operation requires internet but device is offline
class OfflineException extends AppException {
  /// Operation that was attempted
  final String? operation;

  OfflineException({
    String message = 'Operation requires internet connection',
    this.operation,
    String? code = 'OFFLINE',
  }) : super(message, code: code);

  @override
  String toString() => 'OfflineException: $message${operation != null ? " (Operation: $operation)" : ""}';
}

/// Thrown when network request times out
class NetworkTimeoutException extends AppException {
  /// URL that timed out
  final String? url;
  
  /// Timeout duration
  final Duration? timeout;

  NetworkTimeoutException({
    String message = 'Network request timed out',
    this.url,
    this.timeout,
    String? code = 'NETWORK_TIMEOUT',
  }) : super(message, code: code);
}

/// Thrown when server returns error response
class ServerException extends AppException {
  /// HTTP status code
  final int? statusCode;
  
  /// Server error message
  final String? serverMessage;

  ServerException({
    String message = 'Server error occurred',
    this.statusCode,
    this.serverMessage,
    String? code = 'SERVER_ERROR',
  }) : super(message, code: code);
}

/// Thrown when API rate limit is exceeded
class RateLimitException extends AppException {
  /// Time until rate limit resets
  final Duration? retryAfter;

  RateLimitException({
    String message = 'API rate limit exceeded',
    this.retryAfter,
    String? code = 'RATE_LIMIT',
  }) : super(message, code: code);
}

// ============================================================================
// QUEST/MISSION EXCEPTIONS
// ============================================================================

/// Base exception for quest-related errors
abstract class QuestException extends AppException {
  /// Quest ID that caused the exception
  final String? questId;

  QuestException(
    super.message, {
    this.questId,
    super.code,
  });
}

/// Thrown when user tries to accept quest but already has it active
class DuplicateQuestException extends QuestException {
  DuplicateQuestException({
    String message = 'Quest is already active',
    super.questId,
    String? code = 'DUPLICATE_QUEST',
  }) : super(message, code: code);
}

/// Thrown when quest prerequisites are not met
class QuestPrerequisiteException extends QuestException {
  /// List of missing prerequisite quest IDs
  final List<String>? missingPrerequisites;

  QuestPrerequisiteException({
    String message = 'Quest prerequisites not met',
    super.questId,
    this.missingPrerequisites,
    String? code = 'QUEST_PREREQUISITE',
  }) : super(message, code: code);
}

/// Thrown when quest not found in database
class QuestNotFoundException extends QuestException {
  QuestNotFoundException({
    String message = 'Quest not found',
    super.questId,
    String? code = 'QUEST_NOT_FOUND',
  }) : super(message, code: code);
}

/// Thrown when trying to complete quest that isn't finished
class QuestNotCompleteException extends QuestException {
  /// Current progress value
  final int? currentProgress;
  
  /// Required progress value
  final int? requiredProgress;

  QuestNotCompleteException({
    String message = 'Quest progress not complete',
    super.questId,
    this.currentProgress,
    this.requiredProgress,
    String? code = 'QUEST_NOT_COMPLETE',
  }) : super(message, code: code);
}

/// Thrown when quest progress value is invalid
class InvalidQuestProgressException extends QuestException {
  /// Invalid progress value
  final int? invalidValue;
  
  /// Valid progress range
  final String? validRange;

  InvalidQuestProgressException({
    String message = 'Invalid quest progress value',
    super.questId,
    this.invalidValue,
    this.validRange,
    String? code = 'INVALID_QUEST_PROGRESS',
  }) : super(message, code: code);
}

/// Thrown when quest has expired
class QuestExpiredException extends QuestException {
  /// Expiration timestamp
  final DateTime? expiredAt;

  QuestExpiredException({
    String message = 'Quest has expired',
    super.questId,
    this.expiredAt,
    String? code = 'QUEST_EXPIRED',
  }) : super(message, code: code);
}

/// Thrown when quest action is performed too frequently (cooldown)
class QuestCooldownException extends QuestException {
  /// Time until cooldown expires
  final Duration? cooldownRemaining;

  QuestCooldownException({
    String message = 'Quest is on cooldown',
    super.questId,
    this.cooldownRemaining,
    String? code = 'QUEST_COOLDOWN',
  }) : super(message, code: code);
}

// ============================================================================
// ACHIEVEMENT EXCEPTIONS
// ============================================================================

/// Base exception for achievement-related errors
abstract class AchievementException extends AppException {
  /// Achievement ID that caused the exception
  final String? achievementId;

  AchievementException(
    super.message, {
    this.achievementId,
    super.code,
  });
}

/// Thrown when achievement not found
class AchievementNotFoundException extends AchievementException {
  AchievementNotFoundException({
    String message = 'Achievement not found',
    super.achievementId,
    String? code = 'ACHIEVEMENT_NOT_FOUND',
  }) : super(message, code: code);
}

/// Thrown when trying to unlock already unlocked achievement
class AchievementAlreadyUnlockedException extends AchievementException {
  /// When achievement was originally unlocked
  final DateTime? unlockedAt;

  AchievementAlreadyUnlockedException({
    String message = 'Achievement already unlocked',
    super.achievementId,
    this.unlockedAt,
    String? code = 'ACHIEVEMENT_ALREADY_UNLOCKED',
  }) : super(message, code: code);
}

/// Thrown when achievement unlock conditions not met
class AchievementConditionNotMetException extends AchievementException {
  /// Description of unmet condition
  final String? condition;

  AchievementConditionNotMetException({
    String message = 'Achievement unlock conditions not met',
    super.achievementId,
    this.condition,
    String? code = 'ACHIEVEMENT_CONDITION_NOT_MET',
  }) : super(message, code: code);
}

// ============================================================================
// XP & PROGRESSION EXCEPTIONS
// ============================================================================

/// Thrown when XP transaction fails
class XpTransactionException extends AppException {
  /// User ID involved in transaction
  final String? userId;
  
  /// XP amount that failed
  final int? xpAmount;
  
  /// Transaction type (add, deduct, reset)
  final String? transactionType;

  XpTransactionException({
    String message = 'XP transaction failed',
    this.userId,
    this.xpAmount,
    this.transactionType,
    String? code = 'XP_TRANSACTION_FAILED',
  }) : super(message, code: code);
}

/// Thrown when trying to deduct more XP than user has
class InsufficientXpException extends AppException {
  /// Current XP amount
  final int? currentXp;
  
  /// Required XP amount
  final int? requiredXp;

  InsufficientXpException({
    String message = 'Insufficient XP',
    this.currentXp,
    this.requiredXp,
    String? code = 'INSUFFICIENT_XP',
  }) : super(message, code: code);
}

/// Thrown when daily XP cap is reached
class XpCapReachedException extends AppException {
  /// Daily XP cap
  final int? dailyCap;
  
  /// Current XP earned today
  final int? currentXpToday;

  XpCapReachedException({
    String message = 'Daily XP cap reached',
    this.dailyCap,
    this.currentXpToday,
    String? code = 'XP_CAP_REACHED',
  }) : super(message, code: code);
}

/// Thrown when level calculation fails
class LevelCalculationException extends AppException {
  /// XP value that caused error
  final int? xpValue;

  LevelCalculationException({
    String message = 'Failed to calculate level from XP',
    this.xpValue,
    String? code = 'LEVEL_CALCULATION_FAILED',
  }) : super(message, code: code);
}

// ============================================================================
// USER & PROFILE EXCEPTIONS
// ============================================================================

/// Thrown when user not found in database
class UserNotFoundException extends AppException {
  /// User ID that wasn't found
  final String? userId;

  UserNotFoundException({
    String message = 'User not found',
    this.userId,
    String? code = 'USER_NOT_FOUND',
  }) : super(message, code: code);
}

/// Thrown when username is already taken
class UsernameAlreadyExistsException extends AppException {
  /// Username that's taken
  final String? username;

  UsernameAlreadyExistsException({
    String message = 'Username already exists',
    this.username,
    String? code = 'USERNAME_EXISTS',
  }) : super(message, code: code);
}

/// Thrown when email is already registered
class EmailAlreadyExistsException extends AppException {
  /// Email that's taken
  final String? email;

  EmailAlreadyExistsException({
    String message = 'Email already registered',
    this.email,
    String? code = 'EMAIL_EXISTS',
  }) : super(message, code: code);
}

/// Thrown when user tries to perform admin-only action
class UnauthorizedException extends AppException {
  /// Action that was attempted
  final String? action;

  UnauthorizedException({
    String message = 'Unauthorized action',
    this.action,
    String? code = 'UNAUTHORIZED',
  }) : super(message, code: code);
}

/// Thrown when profile update fails validation
class ProfileUpdateException extends AppException {
  /// Field that failed validation
  final String? field;
  
  /// Validation error message
  final String? validationError;

  ProfileUpdateException({
    String message = 'Profile update failed',
    this.field,
    this.validationError,
    String? code = 'PROFILE_UPDATE_FAILED',
  }) : super(message, code: code);
}

// ============================================================================
// COSMETICS & INVENTORY EXCEPTIONS
// ============================================================================

/// Thrown when cosmetic not found
class CosmeticNotFoundException extends AppException {
  /// Cosmetic ID
  final String? cosmeticId;

  CosmeticNotFoundException({
    String message = 'Cosmetic not found',
    this.cosmeticId,
    String? code = 'COSMETIC_NOT_FOUND',
  }) : super(message, code: code);
}

/// Thrown when user tries to equip cosmetic they don't own
class CosmeticNotOwnedException extends AppException {
  /// Cosmetic ID
  final String? cosmeticId;

  CosmeticNotOwnedException({
    String message = 'Cosmetic not owned by user',
    this.cosmeticId,
    String? code = 'COSMETIC_NOT_OWNED',
  }) : super(message, code: code);
}

/// Thrown when cosmetic is already unlocked
class CosmeticAlreadyUnlockedException extends AppException {
  /// Cosmetic ID
  final String? cosmeticId;

  CosmeticAlreadyUnlockedException({
    String message = 'Cosmetic already unlocked',
    this.cosmeticId,
    String? code = 'COSMETIC_ALREADY_UNLOCKED',
  }) : super(message, code: code);
}

// ============================================================================
// STREAK EXCEPTIONS
// ============================================================================

/// Thrown when streak calculation fails
class StreakException extends AppException {
  /// User ID
  final String? userId;
  
  /// Current streak value
  final int? currentStreak;

  StreakException({
    String message = 'Streak calculation failed',
    this.userId,
    this.currentStreak,
    String? code = 'STREAK_FAILED',
  }) : super(message, code: code);
}

/// Thrown when streak is broken
class StreakBrokenException extends AppException {
  /// Previous streak value
  final int? previousStreak;
  
  /// Last activity timestamp
  final DateTime? lastActivity;

  StreakBrokenException({
    String message = 'Streak has been broken',
    this.previousStreak,
    this.lastActivity,
    String? code = 'STREAK_BROKEN',
  }) : super(message, code: code);
}

// ============================================================================
// CACHE EXCEPTIONS
// ============================================================================

/// Thrown when cache operation fails
class CacheException extends AppException {
  /// Cache key that failed
  final String? cacheKey;
  
  /// Cache operation type
  final String? operation;

  CacheException({
    String message = 'Cache operation failed',
    this.cacheKey,
    this.operation,
    String? code = 'CACHE_FAILED',
  }) : super(message, code: code);
}

/// Thrown when cache is expired and no network available
class CacheExpiredException extends AppException {
  /// Cache key that expired
  final String? cacheKey;
  
  /// When cache expired
  final DateTime? expiredAt;

  CacheExpiredException({
    String message = 'Cache expired and offline',
    this.cacheKey,
    this.expiredAt,
    String? code = 'CACHE_EXPIRED',
  }) : super(message, code: code);
}

/// Thrown when no cached data available
class NoCachedDataException extends AppException {
  /// Cache key that was requested
  final String? cacheKey;

  NoCachedDataException({
    String message = 'No cached data available',
    this.cacheKey,
    String? code = 'NO_CACHED_DATA',
  }) : super(message, code: code);
}

// ============================================================================
// VALIDATION EXCEPTIONS
// ============================================================================

/// Base validation exception
class ValidationException extends AppException {
  /// Field that failed validation
  final String? field;
  
  /// Validation rule that failed
  final String? rule;

  ValidationException({
    String message = 'Validation failed',
    this.field,
    this.rule,
    String? code = 'VALIDATION_FAILED',
  }) : super(message, code: code);
}

/// Thrown when input is too short
class InputTooShortException extends ValidationException {
  /// Minimum required length
  final int? minLength;
  
  /// Actual length
  final int? actualLength;

  InputTooShortException({
    String message = 'Input too short',
    super.field,
    this.minLength,
    this.actualLength,
    String? code = 'INPUT_TOO_SHORT',
  }) : super(message: message, code: code);
}

/// Thrown when input is too long
class InputTooLongException extends ValidationException {
  /// Maximum allowed length
  final int? maxLength;
  
  /// Actual length
  final int? actualLength;

  InputTooLongException({
    String message = 'Input too long',
    super.field,
    this.maxLength,
    this.actualLength,
    String? code = 'INPUT_TOO_LONG',
  }) : super(message: message, code: code);
}

/// Thrown when input format is invalid
class InvalidFormatException extends ValidationException {
  /// Expected format description
  final String? expectedFormat;

  InvalidFormatException({
    String message = 'Invalid input format',
    super.field,
    this.expectedFormat,
    String? code = 'INVALID_FORMAT',
  }) : super(message: message, code: code);
}

/// Thrown when required field is missing
class RequiredFieldException extends ValidationException {
  RequiredFieldException({
    String message = 'Required field missing',
    super.field,
    String? code = 'REQUIRED_FIELD',
  }) : super(message: message, code: code);
}

// ============================================================================
// AUTHENTICATION EXCEPTIONS
// ============================================================================

/// Thrown when authentication fails
class AuthenticationException extends AppException {
  /// Reason for auth failure
  final String? reason;

  AuthenticationException({
    String message = 'Authentication failed',
    this.reason,
    String? code = 'AUTH_FAILED',
  }) : super(message, code: code);
}

/// Thrown when session expires
class SessionExpiredException extends AppException {
  SessionExpiredException({
    String message = 'Session expired, please login again',
    String? code = 'SESSION_EXPIRED',
  }) : super(message, code: code);
}

/// Thrown when email not verified
class EmailNotVerifiedException extends AppException {
  /// Email address
  final String? email;

  EmailNotVerifiedException({
    String message = 'Email not verified',
    this.email,
    String? code = 'EMAIL_NOT_VERIFIED',
  }) : super(message, code: code);
}

// ============================================================================
// DATA EXCEPTIONS
// ============================================================================

/// Thrown when database operation fails
class DatabaseException extends AppException {
  /// Table name
  final String? table;
  
  /// Operation type (insert, update, delete, query)
  final String? operation;

  DatabaseException({
    String message = 'Database operation failed',
    this.table,
    this.operation,
    String? code = 'DATABASE_ERROR',
  }) : super(message, code: code);
}

/// Thrown when data serialization fails
class SerializationException extends AppException {
  /// Type that failed to serialize
  final String? type;

  SerializationException({
    String message = 'Data serialization failed',
    this.type,
    String? code = 'SERIALIZATION_FAILED',
  }) : super(message, code: code);
}

/// Thrown when data deserialization fails
class DeserializationException extends AppException {
  /// Type that failed to deserialize
  final String? type;
  
  /// Raw data that failed
  final String? rawData;

  DeserializationException({
    String message = 'Data deserialization failed',
    this.type,
    this.rawData,
    String? code = 'DESERIALIZATION_FAILED',
  }) : super(message, code: code);
}

/// Thrown when duplicate action is attempted
class DuplicateActionException extends AppException {
  /// Action that was duplicated
  final String? action;
  
  /// Entity ID involved
  final String? entityId;

  DuplicateActionException({
    String message = 'Duplicate action attempted',
    this.action,
    this.entityId,
    String? code = 'DUPLICATE_ACTION',
  }) : super(message, code: code);
}

/// Thrown when data not found
class DataNotFoundException extends AppException {
  /// Type of data
  final String? dataType;
  
  /// ID that wasn't found
  final String? id;

  DataNotFoundException({
    String message = 'Data not found',
    this.dataType,
    this.id,
    String? code = 'DATA_NOT_FOUND',
  }) : super(message, code: code);
}

// ============================================================================
// LEADERBOARD EXCEPTIONS
// ============================================================================

/// Thrown when leaderboard data fetch fails
class LeaderboardException extends AppException {
  /// Leaderboard type (xp, achievement, streak)
  final String? leaderboardType;

  LeaderboardException({
    String message = 'Failed to load leaderboard',
    this.leaderboardType,
    String? code = 'LEADERBOARD_FAILED',
  }) : super(message, code: code);
}

// ============================================================================
// NOTIFICATION EXCEPTIONS
// ============================================================================

/// Thrown when notification send fails
class NotificationException extends AppException {
  /// User ID to notify
  final String? userId;
  
  /// Notification type
  final String? notificationType;

  NotificationException({
    String message = 'Failed to send notification',
    this.userId,
    this.notificationType,
    String? code = 'NOTIFICATION_FAILED',
  }) : super(message, code: code);
}

// ============================================================================
// TASK EXCEPTIONS
// ============================================================================

/// Base exception for task-related errors
abstract class TaskException extends AppException {
  /// Task ID that caused the exception
  final String? taskId;

  TaskException(
    super.message, {
    this.taskId,
    super.code,
  });
}

/// Thrown when task not found
class TaskNotFoundException extends TaskException {
  TaskNotFoundException({
    String message = 'Task not found',
    super.taskId,
    String? code = 'TASK_NOT_FOUND',
  }) : super(message, code: code);
}

/// Thrown when task is already completed
class TaskAlreadyCompletedException extends TaskException {
  /// When task was completed
  final DateTime? completedAt;

  TaskAlreadyCompletedException({
    String message = 'Task already completed',
    super.taskId,
    this.completedAt,
    String? code = 'TASK_ALREADY_COMPLETED',
  }) : super(message, code: code);
}

/// Thrown when task deadline has passed
class TaskOverdueException extends TaskException {
  /// Original due date
  final DateTime? dueDate;

  TaskOverdueException({
    String message = 'Task is overdue',
    super.taskId,
    this.dueDate,
    String? code = 'TASK_OVERDUE',
  }) : super(message, code: code);
}
