import 'package:flutter/foundation.dart';
import 'package:nextflix/models/user_model.dart';
import 'package:nextflix/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  // Example: Create user and listen to changes
  Future<void> createAndWatchUser(UserModel user) async {
    try {
      // Create user
      await _userRepository.createUser(user);

      // Listen to user changes
      _userRepository
          .streamUser(user.id!)
          .listen(
            (updatedUser) {
              if (updatedUser != null) {
                debugPrint('User updated: ${updatedUser.displayName}');
                // Handle user updates in UI
              }
            },
            onError: (error) {
              debugPrint('Error streaming user: $error');
            },
          );
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
  }

  // Example: Search and filter users
  Future<List<UserModel>> searchAndFilterUsers(String searchTerm) async {
    try {
      // Get all users first (in real app, you might want to implement server-side search)
      final allUsers = await _userRepository.getAllUsers();

      // Filter on client side
      return allUsers.where((user) {
        return user.displayName?.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ) ==
                true ||
            user.email.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }
}
