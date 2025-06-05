import 'package:flutter/material.dart';
import 'package:nextflix/constants/app_colors.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blend(
        AppColors.darkBackground,
        Colors.transparent,
        1,
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(children: [Text('a')]),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
