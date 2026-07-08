import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../game/avatar_game.dart';

/// Pantalla de pruebas del sistema de avatar (Paso 1).
/// Muestra el personaje caminando en 4 direcciones con teclado o D-pad.
class AvatarPlaygroundScreen extends StatefulWidget {
  const AvatarPlaygroundScreen({super.key});

  @override
  State<AvatarPlaygroundScreen> createState() => _AvatarPlaygroundScreenState();
}

class _AvatarPlaygroundScreenState extends State<AvatarPlaygroundScreen> {
  final AvatarGame _game = AvatarGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avatar (demo)')),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: GameWidget(game: _game, autofocus: true),
            ),
          ),
          _EquipBar(game: _game),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Muévete con WASD / flechas o el D-pad',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          _Dpad(onInput: _game.move),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Barra de chips para equipar/quitar cada capa en vivo.
class _EquipBar extends StatelessWidget {
  final AvatarGame game;
  const _EquipBar({required this.game});

  static const _labels = {
    'pants': 'Pantalón',
    'top': 'Top',
    'hair': 'Pelo',
    'headphones': 'Audífonos',
    'weapon': 'Arma',
  };

  @override
  Widget build(BuildContext context) {
    final layers = game.toggleableLayers;
    return ValueListenableBuilder<int>(
      valueListenable: game.layersRevision,
      builder: (context, _, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: layers.map((layer) {
              final on = game.isOn(layer);
              return FilterChip(
                label: Text(_labels[layer] ?? layer),
                selected: on,
                showCheckmark: false,
                avatar: Icon(
                    on ? Icons.check_circle : Icons.add_circle_outline,
                    size: 16,
                    color: on ? Colors.white : AppColors.textMuted),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                onSelected: (_) => game.toggleLayer(layer),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _Dpad extends StatelessWidget {
  final void Function(Vector2) onInput;
  const _Dpad({required this.onInput});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _btn(Icons.keyboard_arrow_up, Vector2(0, -1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btn(Icons.keyboard_arrow_left, Vector2(-1, 0)),
            const SizedBox(width: 56),
            _btn(Icons.keyboard_arrow_right, Vector2(1, 0)),
          ],
        ),
        _btn(Icons.keyboard_arrow_down, Vector2(0, 1)),
      ],
    );
  }

  Widget _btn(IconData icon, Vector2 dir) {
    return GestureDetector(
      onTapDown: (_) => onInput(dir),
      onTapUp: (_) => onInput(Vector2.zero()),
      onTapCancel: () => onInput(Vector2.zero()),
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surfaceAlt),
        ),
        child: Icon(icon, color: AppColors.accent),
      ),
    );
  }
}
