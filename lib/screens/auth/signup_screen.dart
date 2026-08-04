import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/user_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final ok = await ref.read(userNotifierProvider.notifier).signUp(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          name: _nameCtrl.text.trim(),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo crear la cuenta. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/signup.png',
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
                  stops: [0.0, 0.25, 1.0],
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
                          'CREAR CUENTA',
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
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.next,
                          style: AppTheme.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Nombre',
                            prefixIcon: Icon(Icons.person_outline, size: 20),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Ingresa un nombre'
                              : null,
                        ),
                        const SizedBox(height: 14),
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
                          textInputAction: TextInputAction.next,
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
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Ingresa una contraseña';
                            }
                            if (v.length < 6) return 'Mínimo 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          style: AppTheme.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Confirmar contraseña',
                            prefixIcon: Icon(Icons.lock_outline, size: 20),
                          ),
                          validator: (v) => (v != _passCtrl.text)
                              ? 'Las contraseñas no coinciden'
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
                              : const Text('Registrarme'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('¿Ya tienes cuenta? Inicia sesión'),
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
