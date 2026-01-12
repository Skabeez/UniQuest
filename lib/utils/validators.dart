import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';

/// Centralized validation utility for UniQuest
/// 
/// Provides reusable validation functions for form fields and business logic.
/// All validators return String? for FormField compatibility:
/// - null = valid
/// - String = error message to display
/// 
/// Design Principles:
/// - Single source of truth for validation rules
/// - Consistent error messages across app
/// - Leverages AppConstants for limits
/// - Throws custom exceptions for programmatic validation
/// 
/// Defense Talking Points:
/// - "Centralizes validation logic to prevent duplication"
/// - "Ensures consistent validation rules across all forms"
/// - "Makes validation logic testable and maintainable"
/// - "Follows DRY principle for validation rules"
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  // ============================================================================
  // EMAIL VALIDATION
  // ============================================================================

  /// Validates email address format
  /// 
  /// Rules:
  /// - Required field
  /// - Must match standard email regex pattern
  /// - Allows common TLDs (.com, .edu, .org, etc.)
  /// - Case-insensitive
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();
    
    // Standard email regex pattern
    // Format: local-part@domain.tld
    // Allows: letters, numbers, dots, hyphens, underscores
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null; // Valid
  }

  /// Validates email and throws exception for programmatic use
  static void validateEmailOrThrow(String? email) {
    final error = validateEmail(email);
    if (error != null) {
      throw InvalidFormatException(
        message: error,
        field: 'email',
        expectedFormat: 'user@example.com',
      );
    }
  }

  // ============================================================================
  // PASSWORD VALIDATION
  // ============================================================================

  /// Validates password strength
  /// 
  /// Rules:
  /// - Required field
  /// - Minimum length: 8 characters (AppConstants.validationPasswordMin)
  /// - Maximum length: 128 characters (AppConstants.validationPasswordMax)
  /// - Must contain at least one uppercase letter
  /// - Must contain at least one lowercase letter
  /// - Must contain at least one number
  /// - Must contain at least one special character (!@#$%^&*(),.?":{}|<>)
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    // Check minimum length
    if (password.length < AppConstants.validationPasswordMin) {
      return 'Password must be at least ${AppConstants.validationPasswordMin} characters';
    }

    // Check maximum length
    if (password.length > AppConstants.validationPasswordMax) {
      return 'Password must be less than ${AppConstants.validationPasswordMax} characters';
    }

    // Check for uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null; // Valid
  }

  /// Simple password validation (less strict, for login)
  /// 
  /// Rules:
  /// - Required field
  /// - Minimum length: 8 characters
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validatePasswordSimple(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < AppConstants.validationPasswordMin) {
      return 'Password must be at least ${AppConstants.validationPasswordMin} characters';
    }

    return null; // Valid
  }

  /// Validates password confirmation matches
  /// 
  /// Rules:
  /// - Required field
  /// - Must exactly match the original password
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validatePasswordConfirm(
    String? confirmPassword,
    String? originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (confirmPassword != originalPassword) {
      return 'Passwords do not match';
    }

    return null; // Valid
  }

  // ============================================================================
  // USERNAME VALIDATION
  // ============================================================================

  /// Validates username format
  /// 
  /// Rules:
  /// - Required field
  /// - Minimum length: 3 characters (AppConstants.validationUsernameMin)
  /// - Maximum length: 15 characters (AppConstants.validationUsernameMax)
  /// - Alphanumeric characters only (letters, numbers, underscore)
  /// - Cannot start with a number
  /// - No spaces allowed
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username is required';
    }

    final trimmedUsername = username.trim();

    // Check minimum length
    if (trimmedUsername.length < AppConstants.validationUsernameMin) {
      return 'Username must be at least ${AppConstants.validationUsernameMin} characters';
    }

    // Check maximum length
    if (trimmedUsername.length > AppConstants.validationUsernameMax) {
      return 'Username must be less than ${AppConstants.validationUsernameMax} characters';
    }

    // Check format: alphanumeric and underscore only
    final usernameRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    if (!usernameRegex.hasMatch(trimmedUsername)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null; // Valid
  }

  // ============================================================================
  // QUEST/TASK VALIDATION
  // ============================================================================

  /// Validates quest/task title
  /// 
  /// Rules:
  /// - Required field
  /// - Minimum length: 3 characters
  /// - Maximum length: 50 characters (AppConstants.validationTaskTitleMax)
  /// - Cannot be only whitespace
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateQuestTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title is required';
    }

    final trimmedTitle = title.trim();

    // Check minimum length
    if (trimmedTitle.length < 3) {
      return 'Title must be at least 3 characters';
    }

    // Check maximum length
    if (trimmedTitle.length > AppConstants.validationTaskTitleMax) {
      return 'Title must be less than ${AppConstants.validationTaskTitleMax} characters';
    }

    return null; // Valid
  }

  /// Validates quest/task description
  /// 
  /// Rules:
  /// - Optional field (can be empty)
  /// - If provided, maximum length: 200 characters (AppConstants.validationBioMax)
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateQuestDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return null; // Optional field
    }

    if (description.length > AppConstants.validationBioMax) {
      return 'Description must be less than ${AppConstants.validationBioMax} characters';
    }

    return null; // Valid
  }

  /// Validates quest tags
  /// 
  /// Rules:
  /// - Optional field
  /// - Maximum length: 15 characters
  /// - Comma-separated format
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateQuestTags(String? tags) {
    if (tags == null || tags.trim().isEmpty) {
      return null; // Optional field
    }

    if (tags.length > 15) {
      return 'Tags must be less than 15 characters';
    }

    return null; // Valid
  }

  /// Validates quest notes
  /// 
  /// Rules:
  /// - Optional field
  /// - Maximum length: 200 characters
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateQuestNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) {
      return null; // Optional field
    }

    if (notes.length > AppConstants.validationBioMax) {
      return 'Notes must be less than ${AppConstants.validationBioMax} characters';
    }

    return null; // Valid
  }

  // ============================================================================
  // XP & PROGRESSION VALIDATION
  // ============================================================================

  /// Validates XP amount for transactions
  /// 
  /// Rules:
  /// - Required (cannot be null)
  /// - Must be positive (>= 0)
  /// - Cannot exceed max safe integer
  /// - For deductions, cannot be negative
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateXpAmount(int? xp) {
    if (xp == null) {
      return 'XP amount is required';
    }

    if (xp < 0) {
      return 'XP amount cannot be negative';
    }

    if (xp > 999999999) {
      return 'XP amount too large';
    }

    return null; // Valid
  }

  /// Validates XP amount and throws exception for programmatic use
  static void validateXpAmountOrThrow(int? xp) {
    if (xp == null) {
      throw ValidationException(
        message: 'XP amount is required',
        field: 'xp',
      );
    }

    if (xp < 0) {
      throw ValidationException(
        message: 'XP amount cannot be negative',
        field: 'xp',
        rule: 'positive',
      );
    }

    if (xp > 999999999) {
      throw ValidationException(
        message: 'XP amount exceeds maximum',
        field: 'xp',
        rule: 'max_value',
      );
    }
  }

  /// Validates progress value (0-100)
  /// 
  /// Rules:
  /// - Required (cannot be null)
  /// - Must be between 0 and 100 inclusive
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateProgress(int? progress) {
    if (progress == null) {
      return 'Progress value is required';
    }

    if (progress < AppConstants.progressMin || progress > AppConstants.progressMax) {
      return 'Progress must be between ${AppConstants.progressMin} and ${AppConstants.progressMax}';
    }

    return null; // Valid
  }

  /// Validates progress and throws exception
  static void validateProgressOrThrow(int? progress) {
    if (progress == null) {
      throw ValidationException(
        message: 'Progress is required',
        field: 'progress',
      );
    }

    if (progress < AppConstants.progressMin || progress > AppConstants.progressMax) {
      throw InvalidQuestProgressException(
        message: 'Progress must be between ${AppConstants.progressMin}-${AppConstants.progressMax}',
        invalidValue: progress,
        validRange: '${AppConstants.progressMin}-${AppConstants.progressMax}',
      );
    }
  }

  // ============================================================================
  // PROFILE VALIDATION
  // ============================================================================

  /// Validates bio/description text
  /// 
  /// Rules:
  /// - Optional field
  /// - Maximum length: 200 characters (AppConstants.validationBioMax)
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateBio(String? bio) {
    if (bio == null || bio.trim().isEmpty) {
      return null; // Optional field
    }

    if (bio.length > AppConstants.validationBioMax) {
      return 'Bio must be less than ${AppConstants.validationBioMax} characters';
    }

    return null; // Valid
  }

  // ============================================================================
  // GENERAL PURPOSE VALIDATORS
  // ============================================================================

  /// Validates required field (cannot be empty)
  /// 
  /// Rules:
  /// - Must not be null
  /// - Must not be empty after trimming
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  /// 
  /// Rules:
  /// - Must meet or exceed minLength
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'Field',
  }) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Validates maximum length
  /// 
  /// Rules:
  /// - Must not exceed maxLength
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'Field',
  }) {
    if (value == null) {
      return null; // Allow null for optional fields
    }

    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// Validates length range
  /// 
  /// Rules:
  /// - Must be between minLength and maxLength inclusive
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateLengthRange(
    String? value,
    int minLength,
    int maxLength, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final length = value.trim().length;

    if (length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// Validates numeric range
  /// 
  /// Rules:
  /// - Must be between min and max inclusive
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateRange(
    int? value,
    int min,
    int max, {
    String fieldName = 'Value',
  }) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Validates URL format
  /// 
  /// Rules:
  /// - Must be valid URL format
  /// - Must include protocol (http:// or https://)
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null; // Optional field
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(url)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validates phone number format
  /// 
  /// Rules:
  /// - Optional field
  /// - Must be 10-15 digits
  /// - Can include +, -, (, ), and spaces
  /// 
  /// Returns: null if valid, error message if invalid
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null; // Optional field
    }

    // Remove formatting characters for validation
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // ============================================================================
  // COMPOSITE VALIDATORS
  // ============================================================================

  /// Combines multiple validators into one
  /// 
  /// Executes validators in order, returns first error found
  static String? combineValidators(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Creates a FormFieldValidator that matches FlutterFlow pattern
  /// 
  /// Usage: validator: Validators.asValidator(Validators.validateEmail)
  static String? Function(String?)? asValidator(
    String? Function(String?) validator,
  ) {
    return (value) => validator(value);
  }
}
