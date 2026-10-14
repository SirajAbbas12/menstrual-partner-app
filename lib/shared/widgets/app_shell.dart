import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/cycle/presentation/dashboard_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = <Widget>[
    DashboardScreen(),
    _Placeholder('Daily Log'),
    _Placeholder('Partner Guide'),
    _Placeholder('Premium'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.rose.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.edit_note_outlined),
              selectedIcon: Icon(Icons.edit_note),
              label: 'Log'),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Guide'),
          NavigationDestination(
              icon: Icon(Icons.workspace_premium_outlined),
              selectedIcon: Icon(Icons.workspace_premium),
              label: 'Premium'),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
