import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'avatar_layout.dart';

/// Avatar compuesto por varias capas de sprites superpuestas que comparten el
/// mismo layout ([AvatarLayout]). Cada capa se anima en sincronía según la
/// dirección y el estado actuales.
///
/// Orden de dibujo (de atrás hacia adelante) definido por [layerOrder].
class LayeredAvatar extends PositionComponent {
  LayeredAvatar({this.renderSize = 96});

  /// Tamaño en pantalla del avatar (los 32px nativos se escalan a esto).
  final double renderSize;

  /// Orden de capas: menor índice = más atrás.
  static const List<String> layerOrder = [
    'body',
    'pants',
    'top',
    'hair',
    'headphones',
    'weapon',
  ];

  /// Capa base que no se puede quitar.
  static const String baseLayer = 'body';

  final Map<String, SpriteSheet> _sheets = {};
  final Map<String, SpriteAnimationComponent> _layers = {};

  AvatarDirection _direction = AvatarDirection.down;
  AvatarState _state = AvatarState.idle;

  AvatarDirection get direction => _direction;
  AvatarState get state => _state;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(renderSize);
    anchor = Anchor.center;
  }

  Paint _pixelPaint() => Paint()
    ..filterQuality = FilterQuality.none // pixel art nítido, sin difuminado
    ..isAntiAlias = false;

  int _priorityFor(String layer) {
    final i = layerOrder.indexOf(layer);
    return i < 0 ? layerOrder.length : i;
  }

  /// Equipa (o reemplaza) la capa [layer] con el sprite sheet dado.
  void equip(String layer, SpriteSheet sheet) {
    _sheets[layer] = sheet;
    var comp = _layers[layer];
    if (comp == null) {
      comp = SpriteAnimationComponent(
        size: Vector2.all(renderSize),
        paint: _pixelPaint(),
        priority: _priorityFor(layer),
      );
      _layers[layer] = comp;
      add(comp);
    }
    comp.animation = _animationFor(sheet);
  }

  /// Quita la capa [layer] (excepto la capa base [baseLayer]).
  void unequip(String layer) {
    if (layer == baseLayer) return;
    _layers.remove(layer)?.removeFromParent();
    _sheets.remove(layer);
  }

  bool isEquipped(String layer) => _layers.containsKey(layer);

  /// Cambia la dirección; recompone las animaciones si cambió.
  void setDirection(AvatarDirection dir) {
    if (dir == _direction) return;
    _direction = dir;
    _refresh();
  }

  /// Cambia el estado (idle/walk); recompone las animaciones si cambió.
  void setMotion(AvatarState state) {
    if (state == _state) return;
    _state = state;
    _refresh();
  }

  void _refresh() {
    for (final entry in _layers.entries) {
      final sheet = _sheets[entry.key];
      if (sheet != null) entry.value.animation = _animationFor(sheet);
    }
  }

  SpriteAnimation _animationFor(SpriteSheet sheet) {
    final frames = AvatarLayout.framesFor(_state);
    return sheet.createAnimation(
      row: AvatarLayout.rowFor(_direction),
      stepTime: AvatarLayout.stepTimeFor(_state),
      from: frames.first,
      to: frames.last + 1,
    );
  }
}
