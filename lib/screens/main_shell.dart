import 'package:flutter/material.dart';

import '../config/theme.dart';
import 'home/dashboard_screen.dart';
import 'inventory/inventory_screen.dart';
import 'shop/shop_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [
    DashboardScreen(),
    ShopScreen(),
    InventoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, color: AppColors.textMuted),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.storefront_outlined, color: AppColors.textMuted),
            selectedIcon:
                const Icon(Icons.storefront, color: AppColors.primary),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.backpack_outlined, color: AppColors.textMuted),
            selectedIcon: const Icon(Icons.backpack, color: AppColors.primary),
            label: 'Inventario',
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.person_outline, color: AppColors.textMuted),
            selectedIcon: const Icon(Icons.person, color: AppColors.primary),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
