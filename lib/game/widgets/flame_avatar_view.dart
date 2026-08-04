import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/inventory_provider.dart';
import '../avatar_game.dart';

/// Widget de Avatar en tiempo real renderizado con Flame Engine.
/// Se conecta con [inventoryProvider] para actualizar automáticamente
/// el casco, armadura, espada, escudo, botas o capa según lo equipado.
class FlameAvatarView extends ConsumerStatefulWidget {
  final double size;
  final double playerSize;

  const FlameAvatarView({
    super.key,
    this.size = 64.0,
    this.playerSize = 64.0,
  });

  @override
  ConsumerState<FlameAvatarView> createState() => _FlameAvatarViewState();
}

class _FlameAvatarViewState extends ConsumerState<FlameAvatarView> {
  late final AvatarGame _game;

  @override
  void initState() {
    super.initState();
    _game = AvatarGame(
      background: Colors.transparent,
      playerSize: widget.playerSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);

    inventoryAsync.whenData((items) {
      final equipped = items.where((i) => i.equipped).toList();
      _game.syncEquippedItems(equipped);
    });

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GameWidget(game: _game),
      ),
    );
  }
}
