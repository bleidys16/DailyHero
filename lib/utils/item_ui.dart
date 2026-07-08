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
}
