import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  static const List<String> _basePages = [
    'Dashboard',
    'Map',
    'User Management',
    'Admin Panel',
    'Report',
    'Your Profile',
    'User Panel',
  ];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: title.isNotEmpty && !_basePages.contains(title)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
