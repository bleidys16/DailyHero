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
    ).timeout(const Duration(seconds: 10));
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/carga.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/dailyherologo.png',
                  width: 160,
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    color: AppColors.gold,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
