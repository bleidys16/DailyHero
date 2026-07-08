import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme.dart';
import 'providers/user_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://tjlbaousyxyykftorjpy.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqbGJhb3VzeXh5eWtmdG9yanB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMxODQ1OTksImV4cCI6MjA5ODc2MDU5OX0.ODJRFUxYaZRiAAMGJzTFq6uwnBf8_EdP9qs4zeVb-Rc',
    );
  } catch (e) {
    // Si Supabase falla, la app igual se inicia.
  }

  runApp(
    const ProviderScope(
      child: DailyHeroApp(),
    ),
  );
}

class DailyHeroApp extends StatelessWidget {
  const DailyHeroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyHero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AuthGate(),
    );
  }
}

/// Decide entre splash / login / dashboard según el estado de autenticación.
class AuthGate extends ConsumerWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);
    if (user != null) return const MainShell();

    // Sin usuario en memoria: consultamos la sesión persistida una vez.
    final initial = ref.watch(currentUserProvider);
    final waiting = initial.isLoading || initial.value != null;
    if (waiting) return const _Splash();

    return const LoginScreen();
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_moon, size: 72, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('DailyHero',
                style: AppTheme.pixel
                    .copyWith(fontSize: 28, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
