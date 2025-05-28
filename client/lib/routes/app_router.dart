import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextflix/routes/bottomAppBar_router.dart';

import 'package:nextflix/screens/movie_detail_screen.dart';
import 'package:nextflix/screens/account_screen.dart';
import 'package:nextflix/screens/home_page.dart';
import 'package:nextflix/screens/search_screen.dart';
import 'package:nextflix/screens/splash_screen.dart';
import 'package:nextflix/widgets/auth_gate.dart';
import 'package:nextflix/screens/login_screen.dart';
import 'package:nextflix/screens/register_screen.dart';
import 'routes.dart';

class AppRouter {
  // Các Navigator keys
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter appRouter = GoRouter(
    initialLocation: Routes.splashScreen,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // ShellRoute cho các màn hình có bottom bar
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder:
            (context, state, child) =>
                BottomAppBarRouter(location: state.uri.path, child: child),
        routes: [
          // Các màn hình có bottom bar
          GoRoute(
            path: Routes.homeScreen,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: Routes.searchScreen,
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: Routes.showtimesScreen,
            name: 'showtimes',
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: Routes.accountScreen,
            name: 'account',
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),

      // Các route không có bottom bar
      GoRoute(
        path: Routes.splashScreen,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.authGate,
        name: 'authGate',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        name: 'login',
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: Routes.resigterScreen,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: '/movie/:id',
        parentNavigatorKey: rootNavigatorKey, // Quan trọng!
        pageBuilder: (context, state) {
          final String movieId = state.pathParameters['id'] ?? '0';
          return MaterialPage(
            key: state.pageKey,
            child: MovieDetailScreen(movieId: movieId),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Không tìm thấy trang!'))),
  );
}
