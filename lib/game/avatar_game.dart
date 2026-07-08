import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'avatar/avatar_layout.dart';
import 'avatar/layered_avatar.dart';
import 'avatar/placeholder_sheets.dart';
import 'avatar/player.dart';

/// Juego de demostración del avatar. Renderiza un [Player] por capas que se
/// mueve con teclado (WASD / flechas) o mediante [move] (D-pad táctil).
class AvatarGame extends FlameGame with KeyboardEvents {
  AvatarGame({this.background = const Color(0xFF0F172A)});

  final Color background;
  late final Player player;

  final Map<String, SpriteSheet> _sheets = {};

  /// Se incrementa cuando cambian las capas (para refrescar la UI).
  final ValueNotifier<int> layersRevision = ValueNotifier(0);
  bool _ready = false;

  /// Capas equipadas al inicio (las demás se activan desde la demo).
  static const _defaultEquipped = ['body', 'pants', 'top', 'hair', 'headphones'];

  @override
  Color backgroundColor() => background;

  SpriteSheet _sheetFrom(ui.Image image) =>
      SpriteSheet(image: image, srcSize: Vector2.all(AvatarLayout.frameSize));

  @override
  Future<void> onLoad() async {
    _sheets['body'] = _sheetFrom(await PlaceholderSheets.body());
    _sheets['hair'] = _sheetFrom(await PlaceholderSheets.hair());
    _sheets['top'] = _sheetFrom(await PlaceholderSheets.top());
    _sheets['pants'] = _sheetFrom(await PlaceholderSheets.pants());
    _sheets['headphones'] = _sheetFrom(await PlaceholderSheets.headphones());
    _sheets['weapon'] = _sheetFrom(await PlaceholderSheets.weapon());

    player = Player(renderSize: 120);
    add(player);
    for (final layer in _defaultEquipped) {
      player.equip(layer, _sheets[layer]!);
    }
    _ready = true;
    layersRevision.value++;
  }

  /// Capas que se pueden equipar/quitar en la demo (todas menos la base).
  List<String> get toggleableLayers => LayeredAvatar.layerOrder
      .where((l) => l != LayeredAvatar.baseLayer)
      .toList();

  bool isOn(String layer) => _ready && player.isEquipped(layer);

  /// Alterna una capa (equipar/quitar) usando el sheet ya cargado.
  void toggleLayer(String layer) {
    if (!_ready) return;
    if (player.isEquipped(layer)) {
      player.unequip(layer);
    } else {
      final sheet = _sheets[layer];
      if (sheet != null) player.equip(layer, sheet);
    }
    layersRevision.value++;
  }

  /// Mueve el avatar con un vector de entrada (para el D-pad de la UI).
  void move(Vector2 input) {
    if (_ready) player.setInput(input);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_ready) return KeyEventResult.ignored;
    final left = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final right = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    final up = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final down = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);

    final dx = (right ? 1 : 0) - (left ? 1 : 0);
    final dy = (down ? 1 : 0) - (up ? 1 : 0);
    player.setInput(Vector2(dx.toDouble(), dy.toDouble()));
    return KeyEventResult.handled;
  }
}
