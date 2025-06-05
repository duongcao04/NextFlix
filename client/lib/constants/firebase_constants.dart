class FirebaseConstants {
  // Collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String categoriesCollection = 'categories';
  static const String commentsCollection = 'comments';
  static const String notificationsCollection = 'notifications';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String settingsCollection = 'settings';

  // Storage paths
  static const String profilePicturesPath = 'profile_pictures';
  static const String postImagesPath = 'post_images';
  static const String chatFilesPath = 'chat_files';
  static const String documentsPath = 'documents';

  // Field names
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String deletedAtField = 'deletedAt';
  static const String isActiveField = 'isActive';
  static const String emailField = 'email';
  static const String displayNameField = 'displayName';
  static const String roleField = 'role';
  static const String uidField = 'uid';

  // Firestore limits
  static const int maxBatchSize = 500;
  static const int maxDocumentSize = 1048576; // 1MB in bytes
  static const int maxCollectionDepth = 100;
  static const int maxFieldNameLength = 1500;
  static const int maxFieldValueLength = 1048487; // ~1MB

  // Query limits
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int maxWhereClausesPerQuery = 30;

  // Cache settings
  static const Duration defaultCacheTimeout = Duration(minutes: 5);
  static const Duration longCacheTimeout = Duration(hours: 1);
  static const Duration shortCacheTimeout = Duration(minutes: 1);

  // Error messages
  static const String networkErrorMessage =
      'Network error. Please check your connection and try again.';
  static const String permissionDeniedMessage =
      'Permission denied. You do not have access to this resource.';
  static const String documentNotFoundMessage = 'Document not found.';
  static const String quotaExceededMessage =
      'Quota exceeded. Please try again later.';
  static const String unauthenticatedMessage =
      'Authentication required. Please log in.';
  static const String unavailableMessage =
      'Service temporarily unavailable. Please try again later.';
  static const String dataLossMessage =
      'Data loss occurred. Please contact support.';
  static const String abortedMessage =
      'Operation was aborted. Please try again.';
  static const String outOfRangeMessage = 'Operation out of range.';
  static const String unimplementedMessage = 'Operation not implemented.';
  static const String internalErrorMessage =
      'Internal error occurred. Please contact support.';

  // File upload limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];

  // Security rules
  static const List<String> adminEmails = [
    'admin@nextflit.com',
    'support@nextflit.com',
  ];

  // Pagination
  static const String lastDocumentKey = 'lastDocument';
  static const String hasMoreKey = 'hasMore';

  // Notification types
  static const String notificationTypeComment = 'comment';
  static const String notificationTypeLike = 'like';
  static const String notificationTypeFollow = 'follow';
  static const String notificationTypeMessage = 'message';
  static const String notificationTypeSystem = 'system';

  // User status
  static const String userStatusOnline = 'online';
  static const String userStatusOffline = 'offline';
  static const String userStatusAway = 'away';
  static const String userStatusBusy = 'busy';

  // Privacy settings
  static const String privacyPublic = 'public';
  static const String privacyFriends = 'friends';
  static const String privacyPrivate = 'private';

  // Content moderation
  static const String contentStatusPending = 'pending';
  static const String contentStatusApproved = 'approved';
  static const String contentStatusRejected = 'rejected';
  static const String contentStatusReported = 'reported';

  // Analytics events
  static const String eventUserRegistration = 'user_registration';
  static const String eventUserLogin = 'user_login';
  static const String eventPostCreated = 'post_created';
  static const String eventPostLiked = 'post_liked';
  static const String eventPostShared = 'post_shared';
  static const String eventCommentAdded = 'comment_added';
  static const String eventProfileUpdated = 'profile_updated';
}
