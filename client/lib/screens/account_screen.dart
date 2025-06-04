import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextflix/screens/account_logged_in.dart';
import 'package:nextflix/screens/account_logged_out.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              user == null ? AccountLoggedOut() : AccountLoggedIn(user: user),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.history),
                      title: Text('Lịch sử xem'),
                      onTap: () {
                        // Xử lý khi người dùng nhấn vào
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Yêu thích'),
                      onTap: () {
                        // Xử lý khi người dùng nhấn vào
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Chính sách bảo mật'),
                      onTap: () {
                        // Xử lý khi người dùng nhấn vào
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text('Liên hệ'),
                      onTap: () {
                        // Xử lý khi người dùng nhấn vào
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
