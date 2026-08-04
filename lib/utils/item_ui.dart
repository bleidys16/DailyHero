import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/inventory.dart';

/// Metadatos de presentación para los enums de Item.
class ItemUi {
  // ---------- Tipo ----------
  static String typeLabel(ItemType t) {
    switch (t) {
      case ItemType.weapon:
        return 'Armas';
      case ItemType.armor:
        return 'Armaduras';
      case ItemType.potion:
        return 'Pociones';
      case ItemType.cosmetic:
        return 'Cosméticos';
    }
  }

  static IconData typeIcon(ItemType t) {
    switch (t) {
      case ItemType.weapon:
        return Icons.gavel;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.potion:
        return Icons.science;
      case ItemType.cosmetic:
        return Icons.auto_awesome;
    }
  }

  // ---------- Rareza ----------
  static String rarityLabel(ItemRarity r) {
    switch (r) {
      case ItemRarity.common:
        return 'Común';
      case ItemRarity.uncommon:
        return 'Poco común';
      case ItemRarity.rare:
        return 'Raro';
      case ItemRarity.legendary:
        return 'Legendario';
    }
  }

  static Color rarityColor(ItemRarity r) {
    switch (r) {
      case ItemRarity.common:
        return AppColors.common;
      case ItemRarity.uncommon:
        return AppColors.uncommon;
      case ItemRarity.rare:
        return AppColors.rare;
      case ItemRarity.legendary:
        return AppColors.legendary;
    }
  }

  /// Ruta del sprite PNG del item según su nombre. Si no hay sprite
  /// (pociones, etc.), devuelve null para usar un icono de respaldo.
  static String? itemImage(Item item) {
    final name = item.name.toLowerCase();
    if (name.contains('espada')) return 'assets/sprites/iron_sword.png';
    if (name.contains('escudo')) return 'assets/sprites/guardian_shield.png';
    if (name.contains('armadura')) return 'assets/sprites/leather_armor.png';
    if (name.contains('casco')) return 'assets/sprites/warrior_helmet.png';
    if (name.contains('bota')) return 'assets/sprites/adventurer_boots.png';
    if (name.contains('capa')) return 'assets/sprites/blue_cape.png';
    return null;
  }
}

/// Muestra el item con su sprite PNG si existe; si no, un icono Material
/// del tipo correspondiente (sin emojis).
class ItemIconThumb extends StatelessWidget {
  final Item item;
  final double size;
  const ItemIconThumb({super.key, required this.item, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final img = ItemUi.itemImage(item);
    if (img != null) {
      return Image.asset(
        img,
        fit: BoxFit.contain,
        width: size,
        height: size,
      );
    }
    return Icon(
      ItemUi.typeIcon(item.type),
      color: AppColors.primary,
      size: size * 0.6,
    );
  }
}
