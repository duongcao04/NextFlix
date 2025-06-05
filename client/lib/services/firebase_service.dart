import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getters
  FirebaseDatabase get database => _database;
  FirebaseAuth get auth => _auth;
  FirebaseStorage get storage => _storage;

  // Common database references
  DatabaseReference get users => _database.ref('users');
  DatabaseReference get movies => _database.ref('movies');
  DatabaseReference get featuredMovies => _database.ref('featured_movies');
  DatabaseReference get chats => _database.ref('chats');
  DatabaseReference get messages => _database.ref('messages');

  // Authentication methods
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Disconnect trước để buộc hiển thị bảng chọn tài khoản
      await _googleSignIn.disconnect();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print('Google sign-in was cancelled by user');
        return null;
      }

      print('Google user selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw FirebaseException(
          plugin: 'firebase_auth',
          message: 'Failed to get Google authentication tokens',
        );
      }

      print('Google auth tokens obtained successfully');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Firebase credential created');

      // Sign in to Firebase with the Google user credential
      final userCredential = await _auth.signInWithCredential(credential);

      print('Firebase sign-in completed: ${userCredential.user?.email}');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
        'FirebaseAuthException during Google sign-in: ${e.code} - ${e.message}',
      );
      throw FirebaseException(
        plugin: 'firebase_auth',
        message: 'Google sign-in failed: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      print('General exception during Google sign-in: $e');
      throw FirebaseException(
        plugin: 'firebase_auth',
        message: 'Google sign-in failed: $e',
      );
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        // Sign in to Firebase with the Facebook credential
        final userCredential = await _auth.signInWithCredential(
          facebookCredential,
        );
        return userCredential.user;
      } else {
        throw FirebaseException(
          plugin: 'firebase_auth',
          message: 'Facebook sign-in failed: ${result.message}',
        );
      }
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        message: 'Facebook sign-in failed: $e',
      );
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      // Sign out from all providers
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        message: 'Sign out failed: $e',
      );
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('Không tìm thấy tài khoản với email này.');
        case 'wrong-password':
          return Exception('Mật khẩu không chính xác.');
        case 'email-already-in-use':
          return Exception('Email này đã được sử dụng cho tài khoản khác.');
        case 'weak-password':
          return Exception('Mật khẩu quá yếu.');
        case 'invalid-email':
          return Exception('Địa chỉ email không hợp lệ.');
        case 'user-disabled':
          return Exception('Tài khoản này đã bị vô hiệu hóa.');
        case 'too-many-requests':
          return Exception('Quá nhiều lần thử thất bại. Vui lòng thử lại sau.');
        case 'operation-not-allowed':
          return Exception('Thao tác này không được phép.');
        case 'invalid-credential':
          return Exception('Thông tin đăng nhập không hợp lệ.');
        default:
          return Exception('Đăng nhập thất bại: ${e.message}');
      }
    }
    return Exception('Đăng nhập thất bại: $e');
  }

  // === REALTIME DATABASE CRUD OPERATIONS ===

  // Create data
  Future<String> create(String path, Map<String, dynamic> data) async {
    try {
      // Add server timestamp
      data['createdAt'] = ServerValue.timestamp;
      data['updatedAt'] = ServerValue.timestamp;

      final ref = _database.ref(path).push();
      await ref.set(data);
      return ref.key!;
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to create data: $e',
      );
    }
  }

  // Create data with custom key
  Future<void> createWithKey(
    String path,
    String key,
    Map<String, dynamic> data,
  ) async {
    try {
      data['createdAt'] = ServerValue.timestamp;
      data['updatedAt'] = ServerValue.timestamp;

      await _database.ref('$path/$key').set(data);
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to create data with key: $e',
      );
    }
  }

  // Read single data
  Future<DataSnapshot> read(String path) async {
    try {
      return await _database.ref(path).get();
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to read data: $e',
      );
    }
  }

  // Read with query
  Future<DataSnapshot> readWithQuery(
    String path, {
    String? orderByChild,
    String? orderByKey,
    String? orderByValue,
    dynamic equalTo,
    dynamic startAt,
    dynamic endAt,
    int? limitToFirst,
    int? limitToLast,
  }) async {
    try {
      Query query = _database.ref(path);

      // Apply ordering
      if (orderByChild != null) {
        query = query.orderByChild(orderByChild);
      } else if (orderByKey != null) {
        query = query.orderByKey();
      } else if (orderByValue != null) {
        query = query.orderByValue();
      }

      // Apply filters
      if (equalTo != null) {
        query = query.equalTo(equalTo);
      }
      if (startAt != null) {
        query = query.startAt(startAt);
      }
      if (endAt != null) {
        query = query.endAt(endAt);
      }

      // Apply limits
      if (limitToFirst != null) {
        query = query.limitToFirst(limitToFirst);
      }
      if (limitToLast != null) {
        query = query.limitToLast(limitToLast);
      }

      return await query.get();
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to read data with query: $e',
      );
    }
  }

  // Update data
  Future<void> update(String path, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = ServerValue.timestamp;
      await _database.ref(path).update(data);
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to update data: $e',
      );
    }
  }

  // Delete data
  Future<void> delete(String path) async {
    try {
      await _database.ref(path).remove();
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to delete data: $e',
      );
    }
  }

  // Real-time listeners
  Stream<DatabaseEvent> listenToPath(String path) {
    return _database.ref(path).onValue;
  }

  Stream<DatabaseEvent> listenWithQuery(
    String path, {
    String? orderByChild,
    String? orderByKey,
    String? orderByValue,
    dynamic equalTo,
    dynamic startAt,
    dynamic endAt,
    int? limitToFirst,
    int? limitToLast,
  }) {
    Query query = _database.ref(path);

    // Apply ordering
    if (orderByChild != null) {
      query = query.orderByChild(orderByChild);
    } else if (orderByKey != null) {
      query = query.orderByKey();
    } else if (orderByValue != null) {
      query = query.orderByValue();
    }

    // Apply filters
    if (equalTo != null) {
      query = query.equalTo(equalTo);
    }
    if (startAt != null) {
      query = query.startAt(startAt);
    }
    if (endAt != null) {
      query = query.endAt(endAt);
    }

    // Apply limits
    if (limitToFirst != null) {
      query = query.limitToFirst(limitToFirst);
    }
    if (limitToLast != null) {
      query = query.limitToLast(limitToLast);
    }

    return query.onValue;
  }

  // Batch operations (Multi-path updates)
  Future<void> batchUpdate(Map<String, dynamic> updates) async {
    try {
      // Add timestamp to all updates
      final timestampedUpdates = <String, dynamic>{};
      updates.forEach((path, value) {
        if (value is Map<String, dynamic>) {
          value['updatedAt'] = ServerValue.timestamp;
        }
        timestampedUpdates[path] = value;
      });

      await _database.ref().update(timestampedUpdates);
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to batch update: $e',
      );
    }
  }

  // Transaction operations
  Future<T> runTransaction<T>(
    String path,
    T Function(dynamic currentValue) updateFunction,
  ) async {
    try {
      final result = await _database.ref(path).runTransaction((currentValue) {
        final newValue = updateFunction(currentValue);
        return Transaction.success(newValue);
      });

      return result.snapshot.value as T;
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Transaction failed: $e',
      );
    }
  }

  // Increment counter
  Future<void> incrementCounter(String path, [int increment = 1]) async {
    try {
      await runTransaction<int>(path, (currentValue) {
        int current = 0;
        if (currentValue != null && currentValue is int) {
          current = currentValue;
        }
        return current + increment;
      });
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_database',
        message: 'Failed to increment counter: $e',
      );
    }
  }

  // File upload to Firebase Storage (unchanged)
  Future<String> uploadFile(
    String path,
    List<int> fileBytes, {
    String? contentType,
    Map<String, String>? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(path);

      SettableMetadata uploadMetadata = SettableMetadata(
        contentType: contentType,
        customMetadata: metadata,
      );

      final uploadTask = ref.putData(
        Uint8List.fromList(fileBytes),
        uploadMetadata,
      );
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        message: 'Failed to upload file: $e',
      );
    }
  }

  // Delete file from Firebase Storage (unchanged)
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        message: 'Failed to delete file: $e',
      );
    }
  }

  // === HELPER METHODS ===

  // Check if data exists
  Future<bool> exists(String path) async {
    try {
      final snapshot = await _database.ref(path).get();
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }

  // Get server timestamp
  Map<String, dynamic> get serverTimestamp => {
    'timestamp': ServerValue.timestamp,
  };

  // Convert DataSnapshot to Map
  Map<String, dynamic>? snapshotToMap(DataSnapshot snapshot) {
    if (!snapshot.exists || snapshot.value == null) return null;

    final value = snapshot.value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  // Convert DataSnapshot to List
  List<Map<String, dynamic>> snapshotToList(DataSnapshot snapshot) {
    if (!snapshot.exists || snapshot.value == null) return [];

    final value = snapshot.value;
    if (value is Map) {
      return value.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        data['key'] = entry.key; // Add the key to the data
        return data;
      }).toList();
    }
    return [];
  }
}
