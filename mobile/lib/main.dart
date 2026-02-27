import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';

import 'package:mobile_tmp/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(
    // Membungkus app dengan ProviderScope untuk Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme, // Integrasi Theme Custom
      home: const SplashScreen(),
    );
  }
}
