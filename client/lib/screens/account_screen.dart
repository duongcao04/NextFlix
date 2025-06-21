import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextflix/blocs/authentication_bloc.dart';
import 'package:nextflix/routes/routes.dart';
import 'package:nextflix/screens/account_logged_in.dart';
import 'package:nextflix/screens/account_logged_out.dart';
import 'package:nextflix/routes/app_router.dart';
import 'package:nextflix/screens/contact_screen.dart';
import 'package:nextflix/screens/privacy_policy_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Header based on authentication state
                  if (state is AuthenticationAuthenticated)
                    AccountLoggedIn(user: state.user)
                  else if (state is AuthenticationUnauthenticated)
                    const AccountLoggedOut()
                  else if (state is AuthenticationLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  else
                    const AccountLoggedOut(),

                  const SizedBox(height: 30),

                  // Menu options
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuTile(
                          context,
                          icon: Icons.history,
                          title: 'Lịch sử xem',
                          onTap: () => _navigateToHistory(context),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.favorite,
                          title: 'Yêu thích',
                          onTap: () => _navigateToFavorites(context),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.download,
                          title: 'Tải xuống',
                          onTap: () => _navigateToDownloads(context),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.settings,
                          title: 'Cài đặt',
                          onTap: () => _navigateToSettings(context),
                        ),
                        const Divider(color: Colors.grey),
                        _buildMenuTile(
                          context,
                          icon: Icons.description,
                          title: 'Chính sách bảo mật',
                          onTap: () => _navigateToPrivacyPolicy(context),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.help_outline,
                          title: 'Trợ giúp & Hỗ trợ',
                          onTap: () => _navigateToSupport(context),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.info_outline,
                          title: 'Về chúng tôi',
                          onTap: () => _navigateToAbout(context),
                        ),

                        // Logout option (only show if logged in)
                        if (state is AuthenticationAuthenticated) ...[
                          const Divider(color: Colors.grey),
                          _buildMenuTile(
                            context,
                            icon: Icons.logout,
                            title: 'Đăng xuất',
                            onTap: () => _showLogoutDialog(context),
                            isDestructive: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[600],
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    // TODO: Navigate to watch history screen
    _showComingSoonDialog(context, 'Lịch sử xem');
  }

  void _navigateToFavorites(BuildContext context) {
    // TODO: Navigate to favorites screen
    _showComingSoonDialog(context, 'Danh sách yêu thích');
  }

  void _navigateToDownloads(BuildContext context) {
    // TODO: Navigate to downloads screen
    _showComingSoonDialog(context, 'Tải xuống');
  }

  void _navigateToSettings(BuildContext context) {
    AppRouter.appRouter.go(Routes.settings);
  }

  // ignore: unused_element
  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  void _navigateToSupport(BuildContext context) {
    // TODO: Navigate to support screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ContactScreen()));
  }

  void _navigateToAbout(BuildContext context) {
    // TODO: Navigate to about screen
    _showComingSoonDialog(context, 'Về chúng tôi');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất không?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthenticationBloc>().add(
                  AuthenticationLoggedOut(),
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(feature, style: const TextStyle(color: Colors.white)),
          content: const Text(
            'Tính năng này sẽ có trong phiên bản tiếp theo!',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
