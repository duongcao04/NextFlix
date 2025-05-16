import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextflix/routes/routes.dart';
import 'package:nextflix/screens/home_page.dart';
import 'package:nextflix/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        // Xử lý khi đang chờ xác thực
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Xử lý khi đã xác thực thành công
        if (snapshot.hasData) {
          // Điều hướng rồi trả về widget tạm thời
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(Routes.homeScreen);
          });
          // Trả về màn hình chờ trong khi điều hướng
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Xử lý khi chưa xác thực
        return const LoginPage();
      },
    );
  }
}
