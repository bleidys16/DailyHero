import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/inventory.dart';
import 'avatar/avatar_layout.dart';
import 'avatar/layered_avatar.dart';
import 'avatar/placeholder_sheets.dart';
import 'avatar/player.dart';

/// Juego del avatar. Renderiza un [Player] por capas que se
/// mueve con teclado (WASD / flechas), D-pad o sincroniza su equipamiento.
class AvatarGame extends FlameGame with KeyboardEvents {
  AvatarGame({
    this.background = const Color(0x00000000),
    this.playerSize = 96.0,
  });

  final Color background;
  final double playerSize;
  late final Player player;

  final Map<String, SpriteSheet> _sheets = {};

  /// Se incrementa cuando cambian las capas (para refrescar la UI).
  final ValueNotifier<int> layersRevision = ValueNotifier(0);
  bool _ready = false;
  bool get isReady => _ready;

  List<InventoryItem>? _pendingSyncItems;

  /// Mapeo de capa → nombre del asset PNG en sprites/.
  static const _pngLayers = {
    'cape': 'sprites/blue_cape.png',
    'boots': 'sprites/adventurer_boots.png',
    'helmet': 'sprites/warrior_helmet.png',
    'armor': 'sprites/leather_armor.png',
    'shield': 'sprites/guardian_shield.png',
    'weapon': 'sprites/iron_sword.png',
  };

  @override
  Color backgroundColor() => background;

  SpriteSheet _sheetFrom(ui.Image image) =>
      SpriteSheet(image: image, srcSize: Vector2.all(AvatarLayout.frameSize));

  @override
  Future<void> onLoad() async {
    // Los PNG de capas viven en assets/sprites/, pero el cache de imágenes de
    // Flame usa por defecto el prefijo "assets/images/".
    images.prefix = 'assets/';

    _sheets['body'] = _sheetFrom(await PlaceholderSheets.body());
    _sheets['hair'] = _sheetFrom(await PlaceholderSheets.hair());
    _sheets['top'] = _sheetFrom(await PlaceholderSheets.top());
    _sheets['pants'] = _sheetFrom(await PlaceholderSheets.pants());
    _sheets['headphones'] = _sheetFrom(await PlaceholderSheets.headphones());

    for (final entry in _pngLayers.entries) {
      final img = await images.load(entry.value);
      _sheets[entry.key] = _sheetFrom(img);
    }

    player = Player(renderSize: playerSize);
    add(player);

    // Equipa capas base por defecto
    player.equip('body', _sheets['body']!);
    player.equip('pants', _sheets['pants']!);
    player.equip('top', _sheets['top']!);
    player.equip('hair', _sheets['hair']!);

    _ready = true;

    if (_pendingSyncItems != null) {
      syncEquippedItems(_pendingSyncItems!);
      _pendingSyncItems = null;
    } else {
      layersRevision.value++;
    }
  }

  /// Sincroniza las capas del personaje según los ítems actualmente equipados.
  void syncEquippedItems(List<InventoryItem> equippedItems) {
    if (!_ready) {
      _pendingSyncItems = equippedItems;
      return;
    }

    final activeLayers = <String>{'body', 'pants', 'top', 'hair'};

    for (final inv in equippedItems) {
      final layer = _mapItemToLayer(inv.itemId, inv.item.name);
      if (layer != null) {
        activeLayers.add(layer);
      }
    }

    for (final layer in _pngLayers.keys) {
      if (activeLayers.contains(layer)) {
        if (!player.isEquipped(layer)) {
          final sheet = _sheets[layer];
          if (sheet != null) player.equip(layer, sheet);
        }
      } else {
        if (player.isEquipped(layer)) {
          player.unequip(layer);
        }
      }
    }

    layersRevision.value++;
  }

  static String? _mapItemToLayer(String itemId, String name) {
    final lower = name.toLowerCase();
    if (itemId == 'i1' || lower.contains('espada') || lower.contains('sword')) return 'weapon';
    if (itemId == 'i2' || lower.contains('escudo') || lower.contains('shield')) return 'shield';
    if (itemId == 'i3' || lower.contains('armadura') || lower.contains('armor')) return 'armor';
    if (itemId == 'i4' || lower.contains('casco') || lower.contains('helmet')) return 'helmet';
    if (itemId == 'i5' || lower.contains('botas') || lower.contains('boots')) return 'boots';
    if (itemId == 'i6' || lower.contains('capa') || lower.contains('cape')) return 'cape';
    return null;
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
