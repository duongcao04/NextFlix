import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Không có quyền truy cập dữ liệu';
        case 'not-found':
          return 'Không tìm thấy dữ liệu';
        case 'already-exists':
          return 'Dữ liệu đã tồn tại';
        case 'cancelled':
          return 'Thao tác đã bị hủy';
        case 'deadline-exceeded':
          return 'Quá thời gian chờ';
        case 'internal':
          return 'Lỗi hệ thống nội bộ';
        case 'invalid-argument':
          return 'Dữ liệu không hợp lệ';
        case 'resource-exhausted':
          return 'Tài nguyên đã hết';
        case 'unauthenticated':
          return 'Chưa đăng nhập';
        case 'unavailable':
          return 'Dịch vụ tạm thời không khả dụng';
        case 'unimplemented':
          return 'Tính năng chưa được hỗ trợ';
        case 'unknown':
          return 'Lỗi không xác định';
        default:
          return 'Lỗi Firestore: ${error.message}';
      }
    }

    if (error.toString().contains('network')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet';
    }

    return 'Đã xảy ra lỗi: ${error.toString()}';
  }

  static void logError(String operation, dynamic error, {String? userId}) {
    if (kDebugMode) {
      debugPrint('=== FIRESTORE ERROR ===');
      debugPrint('Operation: $operation');
      debugPrint('User ID: ${userId ?? 'Unknown'}');
      debugPrint('Error: $error');
      debugPrint('Error Type: ${error.runtimeType}');
      if (error is FirebaseException) {
        debugPrint('Error Code: ${error.code}');
        debugPrint('Error Message: ${error.message}');
      }
      debugPrint('=======================');
    }
  }

  static bool isRetryableError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'deadline-exceeded':
        case 'unavailable':
        case 'internal':
        case 'resource-exhausted':
          return true;
        default:
          return false;
      }
    }

    if (error.toString().contains('network')) {
      return true;
    }

    return false;
  }

  static Future<T?> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempts++;

        if (!isRetryableError(error) || attempts >= maxRetries) {
          rethrow;
        }

        logError('Retry attempt $attempts', error);
        await Future.delayed(delay * attempts);
      }
    }

    return null;
  }

  /// Get detailed error information for debugging
  static Map<String, dynamic> getErrorDetails(dynamic error) {
    final details = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'errorType': error.runtimeType.toString(),
      'errorMessage': error.toString(),
      'isRetryable': isRetryableError(error),
    };

    if (error is FirebaseException) {
      details.addAll({
        'code': error.code,
        'message': error.message,
        'plugin': error.plugin,
      });
    }

    return details;
  }

  /// Check if the error is related to network connectivity
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseException) {
      return ['unavailable', 'deadline-exceeded'].contains(error.code);
    }
    return error.toString().toLowerCase().contains('network');
  }

  /// Check if the error is related to permissions
  static bool isPermissionError(dynamic error) {
    if (error is FirebaseException) {
      return ['permission-denied', 'unauthenticated'].contains(error.code);
    }
    return false;
  }

  /// Get suggested action for the user based on error type
  static String getSuggestedAction(dynamic error) {
    if (isNetworkError(error)) {
      return 'Vui lòng kiểm tra kết nối internet và thử lại';
    }

    if (isPermissionError(error)) {
      return 'Vui lòng đăng nhập lại để tiếp tục';
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'quota-exceeded':
          return 'Hệ thống đang quá tải, vui lòng thử lại sau';
        case 'not-found':
          return 'Dữ liệu không tồn tại, vui lòng làm mới trang';
        case 'already-exists':
          return 'Dữ liệu đã tồn tại, vui lòng kiểm tra lại';
        default:
          return 'Vui lòng thử lại sau hoặc liên hệ hỗ trợ';
      }
    }

    return 'Vui lòng thử lại sau';
  }
}

class SafeFirestoreOperation {
  static Future<T?> execute<T>(
    Future<T> Function() operation, {
    String operationName = 'Unknown',
    String? userId,
    T? fallbackValue,
    bool throwOnError = false,
  }) async {
    try {
      return await FirestoreErrorHandler.retryOperation(operation);
    } catch (error) {
      FirestoreErrorHandler.logError(operationName, error, userId: userId);

      if (throwOnError) {
        rethrow;
      }

      // Return fallback value instead of throwing
      return fallbackValue;
    }
  }

  /// Execute operation with error callback
  static Future<T?> executeWithCallback<T>(
    Future<T> Function() operation, {
    required String operationName,
    String? userId,
    T? fallbackValue,
    Function(dynamic error)? onError,
  }) async {
    try {
      return await FirestoreErrorHandler.retryOperation(operation);
    } catch (error) {
      FirestoreErrorHandler.logError(operationName, error, userId: userId);

      if (onError != null) {
        onError(error);
      }

      return fallbackValue;
    }
  }

  /// Execute batch operations safely
  static Future<List<T?>> executeBatch<T>(
    List<Future<T> Function()> operations, {
    String operationName = 'Batch Operation',
    String? userId,
  }) async {
    final results = <T?>[];

    for (int i = 0; i < operations.length; i++) {
      final result = await execute<T>(
        operations[i],
        operationName: '$operationName [$i]',
        userId: userId,
      );
      results.add(result);
    }

    return results;
  }
}

// Extension for easier error handling
extension FirestoreDocumentExtension on DocumentSnapshot {
  bool get existsAndHasData => exists && data() != null;

  /// Get data safely with fallback
  Map<String, dynamic>? get safeData {
    try {
      return data() as Map<String, dynamic>?;
    } catch (e) {
      FirestoreErrorHandler.logError('Document data extraction', e);
      return null;
    }
  }

  /// Get field value safely
  T? getField<T>(String field, {T? defaultValue}) {
    try {
      final data = safeData;
      return data?[field] as T? ?? defaultValue;
    } catch (e) {
      FirestoreErrorHandler.logError('Field extraction: $field', e);
      return defaultValue;
    }
  }
}

extension FirestoreQueryExtension on QuerySnapshot {
  bool get hasData => docs.isNotEmpty;

  /// Get documents safely
  List<DocumentSnapshot> get safeDocs {
    try {
      return docs;
    } catch (e) {
      FirestoreErrorHandler.logError('Query docs extraction', e);
      return [];
    }
  }

  /// Convert to maps safely
  List<Map<String, dynamic>> get safeDataList {
    return safeDocs
        .where((doc) => doc.existsAndHasData)
        .map((doc) => {'id': doc.id, ...doc.safeData ?? {}})
        .toList();
  }
}

/// Error types for better categorization
enum FirestoreErrorType {
  network,
  permission,
  notFound,
  quotaExceeded,
  invalidData,
  unknown,
}

extension FirestoreErrorTypeExtension on FirestoreErrorType {
  String get description {
    switch (this) {
      case FirestoreErrorType.network:
        return 'Lỗi kết nối mạng';
      case FirestoreErrorType.permission:
        return 'Lỗi quyền truy cập';
      case FirestoreErrorType.notFound:
        return 'Không tìm thấy dữ liệu';
      case FirestoreErrorType.quotaExceeded:
        return 'Vượt quá giới hạn';
      case FirestoreErrorType.invalidData:
        return 'Dữ liệu không hợp lệ';
      case FirestoreErrorType.unknown:
        return 'Lỗi không xác định';
    }
  }

  String get userAction {
    switch (this) {
      case FirestoreErrorType.network:
        return 'Kiểm tra kết nối internet';
      case FirestoreErrorType.permission:
        return 'Đăng nhập lại';
      case FirestoreErrorType.notFound:
        return 'Làm mới trang';
      case FirestoreErrorType.quotaExceeded:
        return 'Thử lại sau';
      case FirestoreErrorType.invalidData:
        return 'Kiểm tra dữ liệu nhập';
      case FirestoreErrorType.unknown:
        return 'Liên hệ hỗ trợ';
    }
  }
}

/// Utility to categorize Firestore errors
class FirestoreErrorCategorizer {
  static FirestoreErrorType categorize(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
        case 'deadline-exceeded':
          return FirestoreErrorType.network;
        case 'permission-denied':
        case 'unauthenticated':
          return FirestoreErrorType.permission;
        case 'not-found':
          return FirestoreErrorType.notFound;
        case 'quota-exceeded':
        case 'resource-exhausted':
          return FirestoreErrorType.quotaExceeded;
        case 'invalid-argument':
        case 'failed-precondition':
          return FirestoreErrorType.invalidData;
        default:
          return FirestoreErrorType.unknown;
      }
    }

    if (FirestoreErrorHandler.isNetworkError(error)) {
      return FirestoreErrorType.network;
    }

    return FirestoreErrorType.unknown;
  }
}
