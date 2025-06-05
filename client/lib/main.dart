import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextflix/constants/app_colors.dart';
import 'package:nextflix/routes/app_router.dart';
import 'package:nextflix/firebase_options.dart';
import 'package:nextflix/constants/app_constants.dart';
import 'package:nextflix/repositories/user_repository.dart';
import 'package:nextflix/blocs/authentication_bloc.dart';
import 'package:nextflix/services/firebase_service.dart';

void main() async {
  // Ẩn thanh trạng thái và thanh điều hướng hệ thống
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.edgeToEdge,
  //   overlays: [SystemUiOverlay.top],
  // );

  // Khởi tạo Firebase App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        // Add other repositories here
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create:
                (context) => AuthenticationBloc(
                  userRepository: context.read<UserRepository>(),
                  firebaseService: FirebaseService(),
                )..add(AuthenticationStarted()),
          ),
          // Add other BLoCs here
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          routerConfig: AppRouter.appRouter,
        ),
      ),
    );
  }
}

// Remove duplicate Authentication event and state classes to avoid conflicts with the imported AuthenticationBloc.
