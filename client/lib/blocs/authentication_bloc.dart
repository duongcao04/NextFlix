import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

import '../repositories/user_repository.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

// Events
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String userId;

  AuthenticationLoggedIn({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User? user;

  AuthenticationUserChanged({this.user});

  @override
  List<Object?> get props => [user];
}

// States
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final UserModel user;

  AuthenticationAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final FirebaseService _firebaseService;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({
    required UserRepository userRepository,
    required FirebaseService firebaseService,
  }) : _userRepository = userRepository,
       _firebaseService = firebaseService,
       super(AuthenticationInitial()) {
    // Listen to Firebase Auth state changes
    _userSubscription = _firebaseService.auth.authStateChanges().listen(
      (user) => add(AuthenticationUserChanged(user: user)),
    );

    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationUserChanged>(_onAuthenticationUserChanged);
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);
    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
  }

  Future<void> _onAuthenticationStarted(
    AuthenticationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final firebaseUser = _firebaseService.auth.currentUser;

      if (firebaseUser != null) {
        await _handleAuthenticatedUser(firebaseUser, emit);
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(
        AuthenticationError(message: 'Failed to initialize authentication: $e'),
      );
    }
  }

  Future<void> _onAuthenticationUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (event.user != null) {
      await _handleAuthenticatedUser(event.user!, emit);
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onAuthenticationLoggedIn(
    AuthenticationLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser != null) {
        await _handleAuthenticatedUser(firebaseUser, emit);
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(message: 'Login failed: $e'));
    }
  }

  Future<void> _onAuthenticationLoggedOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _firebaseService.auth.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError(message: 'Logout failed: $e'));
    }
  }

  Future<void> _handleAuthenticatedUser(
    User firebaseUser,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // Check if user exists in Firestore
      UserModel? user = await _userRepository.getUserById(firebaseUser.uid);

      if (user == null) {
        // Create new user in Firestore for first-time users
        print('Creating new user document for: ${firebaseUser.email}');

        user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName:
              firebaseUser.displayName ?? firebaseUser.email?.split('@').first,
          photoURL: firebaseUser.photoURL,
          phoneNumber: firebaseUser.phoneNumber,
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Create user document in Firestore
        try {
          await _userRepository.createUser(user);
          print('User document created successfully');
        } catch (createError) {
          print('Error creating user document: $createError');
          // If creation fails, still proceed with the user object we have
          // This prevents blocking login for Firestore issues
        }
      } else {
        // Update existing user with latest Firebase data if needed
        bool needsUpdate = false;
        Map<String, dynamic> updates = {};

        if (user.email != firebaseUser.email && firebaseUser.email != null) {
          updates['email'] = firebaseUser.email!;
          needsUpdate = true;
        }

        if (user.displayName != firebaseUser.displayName &&
            firebaseUser.displayName != null) {
          updates['displayName'] = firebaseUser.displayName!;
          needsUpdate = true;
        }

        if (user.photoURL != firebaseUser.photoURL &&
            firebaseUser.photoURL != null) {
          updates['photoURL'] = firebaseUser.photoURL!;
          needsUpdate = true;
        }

        if (needsUpdate) {
          try {
            await _userRepository.updateUser(user.id!, updates);
            user = user.copyWith(
              email: firebaseUser.email ?? user.email,
              displayName: firebaseUser.displayName ?? user.displayName,
              photoURL: firebaseUser.photoURL ?? user.photoURL,
              updatedAt: DateTime.now(),
            );
            print('User document updated successfully');
          } catch (updateError) {
            print('Error updating user document: $updateError');
            // Continue with existing user data if update fails
          }
        }
      }

      // Check if user account is active
      if (user!.isActive) {
        emit(AuthenticationAuthenticated(user: user));
        print('User authenticated successfully: ${user.email}');
      } else {
        // User is deactivated
        await _firebaseService.auth.signOut();
        emit(
          AuthenticationError(
            message:
                'Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ.',
          ),
        );
        print('User account is deactivated: ${user.email}');
      }
    } catch (e) {
      print('Error in _handleAuthenticatedUser: $e');

      // If there's any error with Firestore but we have a valid Firebase user,
      // create a minimal user object to allow login
      if (firebaseUser.email != null) {
        final fallbackUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName:
              firebaseUser.displayName ?? firebaseUser.email!.split('@').first,
          photoURL: firebaseUser.photoURL,
          phoneNumber: firebaseUser.phoneNumber,
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        emit(AuthenticationAuthenticated(user: fallbackUser));
        print('Using fallback user data due to Firestore error');

        // Optionally, try to create the user document in the background
        _createUserInBackground(firebaseUser);
      } else {
        emit(
          AuthenticationError(
            message: 'Không thể tải thông tin người dùng: $e',
          ),
        );
      }
    }
  }

  // Background user creation method
  void _createUserInBackground(User firebaseUser) {
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName:
              firebaseUser.displayName ?? firebaseUser.email?.split('@').first,
          photoURL: firebaseUser.photoURL,
          phoneNumber: firebaseUser.phoneNumber,
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(user);
        print('Background user creation successful');
      } catch (e) {
        print('Background user creation failed: $e');
      }
    });
  }

  // Helper methods for authentication operations
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔵 AuthBloc: Starting Google sign-in...');

      final userCredential = await _firebaseService.signInWithGoogle();

      if (userCredential != null) {
        print(
          '🔵 AuthBloc: Google sign-in successful: ${userCredential.user?.email}',
        );

        // Tạo user model cho Realtime Database
        final user = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName:
              userCredential.user!.displayName ??
              userCredential.user!.email?.split('@').first ??
              'User',
          photoURL: userCredential.user!.photoURL,
          phoneNumber: userCredential.user!.phoneNumber,
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Lưu vào Realtime Database
        try {
          await _userRepository.createUser(user);
          print('🟢 AuthBloc: User saved to database successfully');
        } catch (dbError) {
          print('🟡 AuthBloc: Database save error (continuing): $dbError');
          // Không throw error ở đây, vẫn cho phép đăng nhập
        }

        // AuthState sẽ được update tự động qua listener
        return userCredential;
      } else {
        print('🟡 AuthBloc: Google sign-in was cancelled');
        return null;
      }
    } catch (e) {
      print('🔴 AuthBloc: Google sign-in error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final user = await _firebaseService.signInWithFacebook();

      if (user != null) {
        print('Facebook sign-in successful: ${user.email}');

        // Create user model for Realtime Database
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? user.email?.split('@').first,
          photoURL: user.photoURL,
          phoneNumber: user.phoneNumber,
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to Realtime Database (create or update)
        await UserRepository().createUser(userModel);

        // The auth state listener will automatically handle the authentication flow
        return user;
      } else {
        print('Facebook sign-in was cancelled by user');
        return null;
      }
    } catch (e) {
      print('Facebook sign-in error: $e');
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseService.auth.signInWithEmailAndPassword(
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
      return await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Không tìm thấy tài khoản với email này.';
        case 'wrong-password':
          return 'Mật khẩu không chính xác.';
        case 'email-already-in-use':
          return 'Email này đã được sử dụng cho tài khoản khác.';
        case 'weak-password':
          return 'Mật khẩu quá yếu.';
        case 'invalid-email':
          return 'Địa chỉ email không hợp lệ.';
        case 'user-disabled':
          return 'Tài khoản này đã bị vô hiệu hóa.';
        case 'too-many-requests':
          return 'Quá nhiều lần thử thất bại. Vui lòng thử lại sau.';
        case 'operation-not-allowed':
          return 'Thao tác này không được phép.';
        case 'invalid-credential':
          return 'Thông tin đăng nhập không hợp lệ.';

        // Google Sign-In specific errors
        case 'account-exists-with-different-credential':
          return 'Tài khoản đã tồn tại với phương thức đăng nhập khác. Vui lòng sử dụng email/mật khẩu hoặc phương thức đăng nhập ban đầu.';
        case 'invalid-verification-code':
          return 'Mã xác thực không hợp lệ.';
        case 'invalid-verification-id':
          return 'ID xác thực không hợp lệ.';
        case 'credential-already-in-use':
          return 'Thông tin đăng nhập này đã được sử dụng cho tài khoản khác.';

        // Facebook Sign-In specific errors
        case 'popup-closed-by-user':
          return 'Đăng nhập bị hủy bởi người dùng.';
        case 'popup-blocked':
          return 'Cửa sổ đăng nhập bị chặn. Vui lòng cho phép popup và thử lại.';
        case 'cancelled-popup-request':
          return 'Yêu cầu đăng nhập bị hủy.';

        // Network and general errors
        case 'network-request-failed':
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
        case 'internal-error':
          return 'Lỗi hệ thống nội bộ. Vui lòng thử lại sau.';
        case 'app-not-authorized':
          return 'Ứng dụng không được ủy quyền sử dụng Firebase Authentication.';
        case 'keychain-error':
          return 'Lỗi keychain. Vui lòng thử lại.';
        case 'app-not-installed':
          return 'Ứng dụng cần thiết chưa được cài đặt.';

        default:
          return 'Đăng nhập thất bại: ${e.message ?? "Lỗi không xác định"}';
      }
    }

    // Handle other types of errors
    if (e.toString().contains('GoogleSignIn')) {
      return 'Lỗi đăng nhập Google. Vui lòng thử lại.';
    }

    if (e.toString().contains('Facebook')) {
      return 'Lỗi đăng nhập Facebook. Vui lòng thử lại.';
    }

    if (e.toString().contains('network')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
    }

    return 'Đăng nhập thất bại: $e';
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
