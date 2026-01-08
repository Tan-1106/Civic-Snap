import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/common/widgets/custom_app_bar.dart';

class AdminShellLayout extends StatefulWidget {
  final Widget child;

  const AdminShellLayout({super.key, required this.child});

  @override
  State<AdminShellLayout> createState() => _AdminShellLayoutState();
}

class _AdminShellLayoutState extends State<AdminShellLayout> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/admin-map')) return 1;
    if (location.startsWith('/admin-user-management')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin-dashboard');
        break;
      case 1:
        context.go('/admin-map');
        break;
      case 2:
        context.go('/admin-user-management');
        break;
    }
  }

  String _getTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Map';
      case 2:
        return 'User Management';
      default:
        return 'Admin Panel';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(selectedIndex),
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
