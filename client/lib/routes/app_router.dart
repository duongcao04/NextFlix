import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextflix/routes/bottomAppBar_router.dart';
import 'package:nextflix/screens/login_screen.dart';

import 'package:nextflix/screens/movie_detail_screen.dart';
import 'package:nextflix/screens/account_screen.dart';
import 'package:nextflix/screens/home_screen.dart';
import 'package:nextflix/screens/search_screen.dart';
import 'package:nextflix/screens/showtimes.dart';
import 'package:nextflix/screens/splash_screen.dart';
import 'package:nextflix/screens/register_screen.dart';
import 'routes.dart';

class AppRouter {
  // Các Navigator keys
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter appRouter = GoRouter(
    initialLocation: Routes.splash,
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
            path: Routes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.search,
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: Routes.showtimes,
            name: 'showtimes',
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: Routes.account,
            name: 'account',
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),

      // Các route không có bottom bar
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
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
