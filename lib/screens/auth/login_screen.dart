import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final ok = await ref.read(userNotifierProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo iniciar sesión. Revisa tus credenciales.'),
        ),
      );
    }
  }

  Future<void> _enterDemo() async {
    setState(() => _loading = true);
    ref.read(demoModeProvider.notifier).state = true;
    await ref
        .read(userNotifierProvider.notifier)
        .login(email: 'demo', password: 'demo');
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login.png',
            fit: BoxFit.cover,
          ),
          // Degradado solo en la parte inferior: mantiene el logo del
          // fondo totalmente visible y da contraste al formulario.
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.4, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xF2000E1F),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'BIENVENIDO NUEVAMENTE',
                          textAlign: TextAlign.center,
                          style: AppTheme.titleRpg.copyWith(
                            fontSize: 26,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.2,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: AppTheme.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline, size: 20),
                          ),
                          validator: (v) {
                            final value = v?.trim() ?? '';
                            if (value.isEmpty) return 'Ingresa tu email';
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Email no válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          style: AppTheme.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Ingresa tu contraseña'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Entrar'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  ),
                          child: const Text('¿No tienes cuenta? Crea una'),
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _loading ? null : _enterDemo,
                          child: const Text('Probar modo demo'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entra sin cuenta con datos de ejemplo',
                          textAlign: TextAlign.center,
                          style: AppTheme.body.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
