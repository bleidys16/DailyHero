enum ItemRarity { common, uncommon, rare, legendary }

enum ItemType { weapon, armor, potion, cosmetic }

class Item {
  final String id;
  final String name;
  final ItemType type;
  final ItemRarity rarity;
  final int cost;
  final String? description;
  final String icon;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.cost,
    this.description,
    required this.icon,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ItemType.values.byName(json['type'] as String),
      rarity: ItemRarity.values.byName(json['rarity'] as String),
      cost: json['cost'] as int,
      description: json['description'] as String?,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'rarity': rarity.name,
      'cost': cost,
      'description': description,
      'icon': icon,
    };
  }
}

class InventoryItem {
  final String id;
  final String userId;
  final String itemId;
  final Item item;
  final int quantity;
  final bool equipped;
  final DateTime acquiredAt;

  InventoryItem({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.item,
    this.quantity = 1,
    this.equipped = false,
    required this.acquiredAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      equipped: json['equipped'] as bool? ?? false,
      acquiredAt: DateTime.parse(json['acquired_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
      'equipped': equipped,
      'acquired_at': acquiredAt.toIso8601String(),
    };
  }

  InventoryItem copyWith({
    String? id,
    String? userId,
    String? itemId,
    Item? item,
    int? quantity,
    bool? equipped,
    DateTime? acquiredAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      equipped: equipped ?? this.equipped,
      acquiredAt: acquiredAt ?? this.acquiredAt,
    );
  }
}
