import 'package:flame/components.dart';

import 'avatar_layout.dart';
import 'layered_avatar.dart';

/// Avatar controlable: se mueve según un vector de entrada y actualiza su
/// dirección/estado de animación en consecuencia.
class Player extends LayeredAvatar {
  Player({super.renderSize = 96, this.speed = 90});

  /// Velocidad en píxeles por segundo.
  final double speed;

  Vector2 _velocity = Vector2.zero();
  bool _placed = false;

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // Centrar al avatar la primera vez que el juego tiene un tamaño válido.
    if (!_placed && !gameSize.isZero()) {
      position = gameSize / 2;
      _placed = true;
    }
  }

  /// Aplica un vector de entrada (componentes -1, 0 o 1). Vector cero = quieto.
  void setInput(Vector2 input) {
    if (input.isZero()) {
      _velocity = Vector2.zero();
      setMotion(AvatarState.idle);
      return;
    }
    _velocity = input.normalized() * speed;
    // La dirección visible la marca el eje dominante.
    if (input.x.abs() > input.y.abs()) {
      setDirection(input.x > 0 ? AvatarDirection.right : AvatarDirection.left);
    } else {
      setDirection(input.y > 0 ? AvatarDirection.down : AvatarDirection.up);
    }
    setMotion(AvatarState.walk);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_velocity.isZero()) return;
    position += _velocity * dt;
    _clampToBounds();
  }

  void _clampToBounds() {
    final game = findGame();
    if (game == null) return;
    final half = size / 2;
    position.clamp(half, game.size - half);
  }
}
