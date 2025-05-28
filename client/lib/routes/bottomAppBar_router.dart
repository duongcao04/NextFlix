// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextflix/widgets/bottom_app_bar.dart' as custom;

class BottomAppBarRouter extends StatelessWidget {
  final Widget child;
  final String location;

  const BottomAppBarRouter({
    super.key,
    required this.child,
    required this.location,
  });

  static int getCurrentIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/showtimes')) return 2;
    if (location.startsWith('/account')) return 3;
    return 0; // Mặc định là trang đầu tiên
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/showtimes');
        break;
      case 3:
        context.go('/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = getCurrentIndex(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: custom.BottomAppBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
