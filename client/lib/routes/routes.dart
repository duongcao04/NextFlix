class Routes {
  // Authentication routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String profile = '/profile/:userId';
  static const String account = '/account';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Admin routes
  static const String userManagement = '/admin/users';

  // Post routes
  static const String createPost = '/create-post';
  static const String postDetail = '/post/:postId';
  static const String editPost = '/post/:postId/edit';

  // Search routes
  static const String search = '/search';

  // Notification routes
  static const String notifications = '/notifications';

  // Chat routes
  static const String chats = '/chats';
  static const String chatDetail = '/chat/:chatId';

  // Helper methods to generate routes with parameters
  static String profileRoute(String userId) {
    return profile.replaceAll(':userId', userId);
  }

  static String postDetailRoute(String postId) {
    return postDetail.replaceAll(':postId', postId);
  }

  static String editPostRoute(String postId) {
    return editPost.replaceAll(':postId', postId);
  }

  static String chatDetailRoute(String chatId) {
    return chatDetail.replaceAll(':chatId', chatId);
  }

  static String searchRoute({String? query}) {
    if (query != null && query.isNotEmpty) {
      return '$search?q=${Uri.encodeComponent(query)}';
    }
    return search;
  }
}
