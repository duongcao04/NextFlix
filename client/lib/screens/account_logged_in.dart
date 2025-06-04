import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AccountLoggedIn extends StatelessWidget {
  final User user;

  const AccountLoggedIn({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName ?? user.email ?? 'User';

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              backgroundImage:
                  user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              child:
                  user.photoURL == null
                      ? Text(
                        displayName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text("Quản lý tài khoản"),
              onPressed: () {
                // Mở trang quản lý nếu bạn có
              },
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Đăng xuất"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
