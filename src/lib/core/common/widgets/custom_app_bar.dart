import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/init_dependencies.dart';
import 'package:src/core/services/secure_storage_service.dart';

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

  Future<void> _showLogoutDialog(BuildContext context) async {
    final router = GoRouter.of(context);

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await serviceLocator<SecureStorageService>().clearCredentials();
      router.go('/sign-in');
    }
  }

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
      actions: [
        if (title == 'User Management' || title == 'Your Profile')
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
      ],
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
