import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/local_store.dart';
import 'features/notifications/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/app_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();
  await NotificationService.init();
  NotificationService.refresh();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cycle Partner',
      theme: AppTheme.light(),
      home: LocalStore.onboarded ? const AppShell() : const OnboardingScreen(),
    );
  }
}
