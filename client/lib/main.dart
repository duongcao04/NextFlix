import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nextflix/constants/routes.dart';
import 'package:nextflix/firebase_options.dart';
import 'package:nextflix/constants/app_constants.dart';
import 'package:nextflix/screens/home_page.dart';
import 'package:nextflix/screens/login_screen.dart';
import 'package:nextflix/screens/register_screen.dart';

import 'screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.loginScreen: (context) => const LoginPage(),
        Routes.splashScreen: (context) => const SplashScreen(),
        Routes.resigterScreen: (context) => const RegisterPage(),
        Routes.homeScreen: (context) => const HomePage(),
      },
    );
  }
}
