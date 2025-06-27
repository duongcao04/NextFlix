import 'package:flutter/foundation.dart';
import 'package:nextflix/models/user_model.dart';
import 'package:nextflix/services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // === USER CRUD OPERATIONS ===

  // Create user with UID as key
  Future<void> createUser(UserModel user) async {
    try {
      final userData = user.toJson();
      await _firebaseService.createWithKey(
        'users',
        user.id.toString(),
        userData,
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final snapshot = await _firebaseService.read('users/$userId');

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data['id'] = userId; // Add ID to the data
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firebaseService.read('users');

      if (snapshot.exists && snapshot.value != null) {
        final usersMap = Map<String, dynamic>.from(snapshot.value as Map);

        return usersMap.entries.map((entry) {
          final userData = Map<String, dynamic>.from(entry.value as Map);
          userData['id'] = entry.key; // Add the user ID
          return UserModel.fromJson(userData);
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }

  // Search users by email
  Future<List<UserModel>> searchUsersByEmail(String email) async {
    try {
      final snapshot = await _firebaseService.readWithQuery(
        'users',
        orderByChild: 'email',
        equalTo: email,
      );

      return _firebaseService
          .snapshotToList(snapshot)
          .map((data) => UserModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error searching users by email: $e');
      return [];
    }
  }

  // Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final snapshot = await _firebaseService.readWithQuery(
        'users',
        orderByChild: 'role',
        equalTo: role,
      );

      return _firebaseService
          .snapshotToList(snapshot)
          .map((data) => UserModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error getting users by role: $e');
      return [];
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firebaseService.update('users/$userId', updates);
      debugPrint('User updated successfully: $userId');
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firebaseService.delete('users/$userId');
      debugPrint('User deleted successfully: $userId');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // === REAL-TIME LISTENERS ===

  // Stream user data
  Stream<UserModel?> streamUser(String userId) {
    return _firebaseService.listenToPath('users/$userId').map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data['id'] = userId;
        return UserModel.fromJson(data);
      }
      return null;
    });
  }

  // Stream all users
  Stream<List<UserModel>> streamAllUsers() {
    return _firebaseService.listenToPath('users').map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final usersMap = Map<String, dynamic>.from(event.snapshot.value as Map);

        return usersMap.entries.map((entry) {
          final userData = Map<String, dynamic>.from(entry.value as Map);
          userData['id'] = entry.key;
          return UserModel.fromJson(userData);
        }).toList();
      }
      return <UserModel>[];
    });
  }

  // Stream active users
  Stream<List<UserModel>> streamActiveUsers() {
    return _firebaseService
        .listenWithQuery('users', orderByChild: 'isActive', equalTo: true)
        .map((event) {
          return _firebaseService
              .snapshotToList(event.snapshot)
              .map((data) => UserModel.fromJson(data))
              .toList();
        });
  }
}
