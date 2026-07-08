// Smoke test básico de DailyHero.
//
// La app real depende de Supabase (inicializado en main()), por lo que aquí
// solo verificamos que el árbol de widgets base se construya sin errores
// dentro de un ProviderScope.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailyhero/config/theme.dart';

void main() {
  testWidgets('El tema y un Scaffold básico se renderizan', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(body: Center(child: Text('DailyHero'))),
        ),
      ),
    );

    expect(find.text('DailyHero'), findsOneWidget);
  });
}
