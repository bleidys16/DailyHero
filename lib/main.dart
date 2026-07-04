import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://tjlbaousyxyykftorjpy.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqbGJhb3VzeXh5eWtmdG9yanB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMxODQ1OTksImV4cCI6MjA5ODc2MDU5OX0.ODJRFUxYaZRiAAMGJzTFq6uwnBf8_EdP9qs4zeVb-Rc',
    );
  } catch (e) {
    // Si Supabase falla, la app igual se inicia
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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1E293B),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyHero'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Bienvenido a DailyHero',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Tu dashboard irá aquí'),
          ],
        ),
      ),
    );
  }
}
