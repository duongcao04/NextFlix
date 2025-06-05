import 'package:flutter/material.dart';
import 'package:nextflix/routes/app_router.dart';
import 'package:nextflix/routes/routes.dart';

class AccountLoggedOut extends StatelessWidget {
  const AccountLoggedOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.account_circle, size: 50),
            const SizedBox(width: 10),
            Text(
              'Tài khoản',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGradientButton(
              icon: Icons.login,
              text: 'Đăng nhập',
              onPressed: () {
                AppRouter.appRouter.go(Routes.login);
              },
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                AppRouter.appRouter.go(Routes.register);
              },
              icon: const Icon(Icons.app_registration, size: 20),
              label: const Text('Đăng ký', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildGradientButton({
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return Material(
    borderRadius: BorderRadius.circular(12),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF4AD), Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
