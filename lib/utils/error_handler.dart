import 'package:flutter/material.dart';
import '../exceptions/app_exceptions.dart';

/// Centralized error handling utility for UniQuest
/// 
/// Converts technical exceptions to user-friendly messages and
/// provides consistent UI feedback for errors across the app.
/// 
/// Design Principles:
/// - User-friendly, non-technical error messages
/// - Consistent error display UI
/// - Logging integration point
/// - Graceful degradation for unknown errors
/// 
/// Defense Talking Points:
/// - "Centralizes error handling logic"
/// - "Improves user experience with friendly messages"
/// - "Makes error handling consistent across app"
/// - "Simplifies error handling in UI code"
class ErrorHandler {
  // Private constructor to prevent instantiation
  ErrorHandler._();

  // ============================================================================
  // CORE ERROR HANDLING METHODS
  // ============================================================================

  /// Converts any error/exception to a user-friendly message
  /// 
  /// Returns localized, non-technical message suitable for display
  /// Falls back to generic message for unknown errors
  static String getUserMessage(dynamic error) {
    // Handle null
    if (error == null) {
      return 'An unexpected error occurred';
    }

    // Handle custom app exceptions
    if (error is AppException) {
      return _getAppExceptionMessage(error);
    }

    // Handle Flutter/Dart built-in exceptions
    if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    }
    if (error is TypeError) {
      return 'Data type mismatch. Please try again.';
    }
    if (error is RangeError) {
      return 'Value out of range. Please check your input.';
    }

    // Handle string errors
    if (error is String) {
      return error;
    }

    // Fallback for unknown errors
    return 'An unexpected error occurred. Please try again.';
  }

  /// Shows error to user via SnackBar
  /// 
  /// Displays error message at bottom of screen with action button
  static void showError(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final message = getUserMessage(error);
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onAction ?? () {},
              )
            : null,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Log error for debugging
    _logError(error);
  }

  /// Shows error in dialog
  /// 
  /// More prominent than SnackBar, requires user dismissal
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String title = 'Error',
    String? customMessage,
    List<Widget>? actions,
  }) async {
    final message = customMessage ?? getUserMessage(error);

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
      ),
    );
  }

  /// Shows error with retry option
  /// 
  /// Useful for transient network errors
  static void showErrorWithRetry(
    BuildContext context,
    dynamic error,
    VoidCallback onRetry,
  ) {
    showError(
      context,
      error,
      actionLabel: 'Retry',
      onAction: onRetry,
      duration: const Duration(seconds: 6),
    );
  }

  // ============================================================================
  // EXCEPTION MESSAGE MAPPING
  // ============================================================================

  /// Maps AppException subtypes to user-friendly messages
  static String _getAppExceptionMessage(AppException exception) {
    // Network & Connectivity
    if (exception is OfflineException) {
      return 'You\'re offline. Please check your internet connection.';
    }
    if (exception is NetworkTimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    }
    if (exception is ServerException) {
      if (exception.statusCode == 500) {
        return 'Server error. Please try again later.';
      }
      if (exception.statusCode == 503) {
        return 'Service temporarily unavailable. Please try again later.';
      }
      return exception.serverMessage ?? 'Server error occurred. Please try again.';
    }
    if (exception is RateLimitException) {
      return 'Too many requests. Please wait a moment before trying again.';
    }

    // Quest Exceptions
    if (exception is DuplicateQuestException) {
      return 'You already have this quest active.';
    }
    if (exception is QuestPrerequisiteException) {
      return 'Complete prerequisite quests first.';
    }
    if (exception is QuestNotFoundException) {
      return 'Quest not found. It may have been removed.';
    }
    if (exception is QuestNotCompleteException) {
      return 'Quest not yet complete. Keep making progress!';
    }
    if (exception is InvalidQuestProgressException) {
      return 'Invalid progress value. Please try again.';
    }
    if (exception is QuestExpiredException) {
      return 'This quest has expired.';
    }
    if (exception is QuestCooldownException) {
      return 'Quest on cooldown. Try again later.';
    }

    // Achievement Exceptions
    if (exception is AchievementNotFoundException) {
      return 'Achievement not found.';
    }
    if (exception is AchievementAlreadyUnlockedException) {
      return 'You\'ve already unlocked this achievement.';
    }
    if (exception is AchievementConditionNotMetException) {
      return 'Achievement unlock conditions not met yet.';
    }

    // XP & Progression
    if (exception is XpTransactionException) {
      return 'Failed to update XP. Please try again.';
    }
    if (exception is InsufficientXpException) {
      return 'Not enough XP for this action.';
    }
    if (exception is XpCapReachedException) {
      return 'Daily XP cap reached. Come back tomorrow!';
    }
    if (exception is LevelCalculationException) {
      return 'Error calculating level. Please refresh.';
    }

    // User & Profile
    if (exception is UserNotFoundException) {
      return 'User not found.';
    }
    if (exception is UsernameAlreadyExistsException) {
      return 'Username already taken. Please choose another.';
    }
    if (exception is EmailAlreadyExistsException) {
      return 'Email already registered. Try logging in.';
    }
    if (exception is UnauthorizedException) {
      return 'You don\'t have permission for this action.';
    }
    if (exception is ProfileUpdateException) {
      return exception.validationError ?? 'Failed to update profile. Please check your input.';
    }

    // Cosmetics
    if (exception is CosmeticNotFoundException) {
      return 'Cosmetic item not found.';
    }
    if (exception is CosmeticNotOwnedException) {
      return 'You don\'t own this cosmetic item.';
    }
    if (exception is CosmeticAlreadyUnlockedException) {
      return 'You already have this cosmetic unlocked.';
    }

    // Streaks
    if (exception is StreakException) {
      return 'Error updating streak. Please try again.';
    }
    if (exception is StreakBrokenException) {
      return 'Your streak has been broken. Start a new one!';
    }

    // Cache
    if (exception is CacheExpiredException) {
      return 'Data expired and you\'re offline. Connect to refresh.';
    }
    if (exception is NoCachedDataException) {
      return 'No offline data available. Connect to load.';
    }
    if (exception is CacheException) {
      return 'Cache error. Please try again.';
    }

    // Validation
    if (exception is InputTooShortException) {
      return 'Input too short. Minimum ${exception.minLength} characters required.';
    }
    if (exception is InputTooLongException) {
      return 'Input too long. Maximum ${exception.maxLength} characters allowed.';
    }
    if (exception is InvalidFormatException) {
      return 'Invalid format. ${exception.expectedFormat ?? "Please check your input."}';
    }
    if (exception is RequiredFieldException) {
      return '${exception.field ?? "Required field"} is missing.';
    }
    if (exception is ValidationException) {
      return exception.message;
    }

    // Authentication
    if (exception is SessionExpiredException) {
      return 'Session expired. Please log in again.';
    }
    if (exception is EmailNotVerifiedException) {
      return 'Please verify your email before continuing.';
    }
    if (exception is AuthenticationException) {
      return 'Authentication failed. ${exception.reason ?? "Please try again."}';
    }

    // Data
    if (exception is DuplicateActionException) {
      return 'This action has already been performed.';
    }
    if (exception is DataNotFoundException) {
      return '${exception.dataType ?? "Data"} not found.';
    }
    if (exception is DatabaseException) {
      return 'Database error. Please try again.';
    }
    if (exception is SerializationException) {
      return 'Data save error. Please try again.';
    }
    if (exception is DeserializationException) {
      return 'Data load error. Please try again.';
    }

    // Leaderboard
    if (exception is LeaderboardException) {
      return 'Failed to load leaderboard. Please try again.';
    }

    // Notifications
    if (exception is NotificationException) {
      return 'Failed to send notification.';
    }

    // Tasks
    if (exception is TaskNotFoundException) {
      return 'Task not found.';
    }
    if (exception is TaskAlreadyCompletedException) {
      return 'Task already completed.';
    }
    if (exception is TaskOverdueException) {
      return 'Task is overdue.';
    }

    // Fallback for base exceptions
    return exception.message;
  }

  // ============================================================================
  // ERROR SEVERITY CLASSIFICATION
  // ============================================================================

  /// Determines severity level of error for logging/alerting
  static ErrorSeverity getSeverity(dynamic error) {
    if (error is OfflineException) return ErrorSeverity.info;
    if (error is CacheExpiredException) return ErrorSeverity.warning;
    if (error is NetworkTimeoutException) return ErrorSeverity.warning;
    if (error is ValidationException) return ErrorSeverity.info;
    if (error is DuplicateActionException) return ErrorSeverity.info;
    if (error is QuestCooldownException) return ErrorSeverity.info;
    if (error is XpCapReachedException) return ErrorSeverity.info;
    
    if (error is ServerException) return ErrorSeverity.error;
    if (error is DatabaseException) return ErrorSeverity.error;
    if (error is AuthenticationException) return ErrorSeverity.error;
    
    return ErrorSeverity.error; // Default to error for unknown
  }

  /// Checks if error should trigger retry prompt
  static bool shouldOfferRetry(dynamic error) {
    return error is NetworkTimeoutException ||
        error is ServerException ||
        error is OfflineException ||
        error is CacheExpiredException;
  }

  /// Checks if error is recoverable
  static bool isRecoverable(dynamic error) {
    // Non-recoverable errors
    if (error is QuestNotFoundException) return false;
    if (error is UserNotFoundException) return false;
    if (error is UnauthorizedException) return false;
    if (error is SessionExpiredException) return false;
    
    // Most errors are recoverable
    return true;
  }

  // ============================================================================
  // ERROR LOGGING
  // ============================================================================

  /// Logs error to console/analytics
  /// 
  /// In production, this would send to Firebase Analytics, Sentry, etc.
  static void _logError(dynamic error) {
    final severity = getSeverity(error);
    final timestamp = DateTime.now().toIso8601String();
    
    debugPrint('[$timestamp] [$severity] Error: $error');
    
    // In production, add:
    // - Firebase Crashlytics logging
    // - Analytics event tracking
    // - Error aggregation service
    
    if (error is AppException && error.stackTrace != null) {
      debugPrint('Stack trace: ${error.stackTrace}');
    }
  }

  /// Records error for analytics
  static void recordError(dynamic error, {Map<String, dynamic>? metadata}) {
    // Production implementation would use:
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'app_error',
    //   parameters: {
    //     'error_type': error.runtimeType.toString(),
    //     'error_message': getUserMessage(error),
    //     'severity': getSeverity(error).name,
    //     ...?metadata,
    //   },
    // );
    
    _logError(error);
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Gets appropriate icon for error type
  static IconData getErrorIcon(dynamic error) {
    if (error is OfflineException) return Icons.wifi_off;
    if (error is NetworkTimeoutException) return Icons.access_time;
    if (error is ValidationException) return Icons.error_outline;
    if (error is UnauthorizedException) return Icons.lock;
    if (error is QuestException) return Icons.map;
    if (error is AchievementException) return Icons.emoji_events;
    if (error is XpTransactionException) return Icons.stars;
    
    return Icons.error; // Default error icon
  }

  /// Gets appropriate color for error severity
  static Color getErrorColor(dynamic error) {
    final severity = getSeverity(error);
    
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.deepPurple;
    }
  }

  /// Creates formatted error report for debugging
  static String getDebugReport(dynamic error) {
    final buffer = StringBuffer();
    buffer.writeln('=== ERROR REPORT ===');
    buffer.writeln('Time: ${DateTime.now()}');
    buffer.writeln('Type: ${error.runtimeType}');
    buffer.writeln('Severity: ${getSeverity(error).name}');
    buffer.writeln('Message: ${getUserMessage(error)}');
    
    if (error is AppException) {
      buffer.writeln('Code: ${error.code}');
      buffer.writeln('Technical: ${error.message}');
      if (error.stackTrace != null) {
        buffer.writeln('Stack trace:');
        buffer.writeln(error.stackTrace);
      }
    }
    
    buffer.writeln('===================');
    return buffer.toString();
  }
}

// ============================================================================
// ERROR SEVERITY ENUM
// ============================================================================

/// Severity levels for error classification
enum ErrorSeverity {
  /// Informational - user should be aware but no action needed
  info,
  
  /// Warning - something went wrong but operation can continue
  warning,
  
  /// Error - operation failed, user action required
  error,
  
  /// Critical - serious error requiring immediate attention
  critical,
}

// ============================================================================
// ERROR HANDLING EXTENSIONS
// ============================================================================

/// Extension on BuildContext for convenient error handling
extension ErrorHandlingContext on BuildContext {
  /// Shows error message using ErrorHandler
  void showError(dynamic error) {
    ErrorHandler.showError(this, error);
  }

  /// Shows error dialog using ErrorHandler
  Future<void> showErrorDialog(dynamic error, {String? title}) {
    return ErrorHandler.showErrorDialog(this, error, title: title ?? 'Error');
  }

  /// Shows error with retry option
  void showErrorWithRetry(dynamic error, VoidCallback onRetry) {
    ErrorHandler.showErrorWithRetry(this, error, onRetry);
  }
}
