/// Result type for handling success and failure cases
/// Demonstrates proper error handling pattern for defense
abstract class Result<T> {
  const Result();

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get data => isSuccess ? (this as Success<T>).value : null;

  /// Get error if failure, null otherwise
  String? get error => isFailure ? (this as Failure<T>).message : null;

  /// Execute callback if success
  Result<T> onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).value);
    }
    return this;
  }

  /// Execute callback if failure
  Result<T> onFailure(void Function(String error) callback) {
    if (this is Failure<T>) {
      callback((this as Failure<T>).message);
    }
    return this;
  }

  /// Transform success value
  Result<R> map<R>(R Function(T data) transform) {
    if (this is Success<T>) {
      try {
        return Success(transform((this as Success<T>).value));
      } catch (e) {
        return Failure(e.toString());
      }
    }
    return Failure((this as Failure<T>).message);
  }

  /// Async transform success value
  Future<Result<R>> mapAsync<R>(
      Future<R> Function(T data) transform) async {
    if (this is Success<T>) {
      try {
        final result = await transform((this as Success<T>).value);
        return Success(result);
      } catch (e) {
        return Failure(e.toString());
      }
    }
    return Failure((this as Failure<T>).message);
  }

  /// Pattern matching for Result
  /// Executes onSuccess or onFailure callback based on result type
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else {
      return failure((this as Failure<T>).message);
    }
  }
}

/// Success case of Result type
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';
}

/// Failure case of Result type
class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const Failure(this.message, {this.exception});

  @override
  String toString() => 'Failure($message)';
}
