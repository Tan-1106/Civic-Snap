import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/common/widgets/custom_app_bar.dart';

class UserShellLayout extends StatefulWidget {
  final Widget child;

  const UserShellLayout({super.key, required this.child});

  @override
  State<UserShellLayout> createState() => _UserShellLayoutState();
}

class _UserShellLayoutState extends State<UserShellLayout> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/user-report')) return 1;
    if (location.startsWith('/user-profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/user-map');
        break;
      case 1:
        context.go('/user-report');
        break;
      case 2:
        context.go('/user-profile');
        break;
    }
  }

  String _getTitle(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/user-report')) return 'Report';
    if (location.startsWith('/user-profile')) return 'Your Profile';
    if (location.startsWith('/user-map')) return 'Map';
    return 'User Panel';
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(context),
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
