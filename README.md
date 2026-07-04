# DailyHero

**DailyHero** transforma tu rutina diaria en un videojuego RPG de pixel art. Cada hábito que cumples (estudiar, hacer ejercicio, meditar) se convierte en una misión que le da experiencia (XP) y oro a tu héroe. Si fallas, tu personaje pierde HP. Con el oro puedes comprar armas, armaduras, pociones y skins en la tienda para personalizar tu avatar.

Hecho en **Flutter** + **Supabase** + **Riverpod**.

---

## Setup inicial

1. **Instala Flutter**
   ```bash
   flutter --version
   flutter doctor
   ```

2. **Clona el repo**
   ```bash
   git clone https://github.com/bleidys16/dailyhero.git
   cd dailyhero
   ```

3. **Instala dependencias**
   ```bash
   flutter pub get
   ```

4. **Configura `.env`**
   - Pide las credenciales de Supabase (`SUPABASE_URL` y `SUPABASE_ANON_KEY`)
   - Crea archivo `.env` en la raíz con esas credenciales

5. **Corre la app**
   ```bash
   flutter run -d chrome   # Web
   flutter run             # Android / iOS
   ```

---

## Estructura del proyecto

```
lib/
├── main.dart               # Entry point
├── config/                 # Tema, colores, constantes
│   └── theme.dart
├── models/                 # Entidades de datos
│   ├── user.dart
│   ├── habit.dart
│   ├── mission.dart
│   └── inventory.dart
├── services/               # Lógica de Supabase
│   └── supabase_service.dart
├── providers/              # State management (Riverpod)
│   ├── user_provider.dart
│   ├── habit_provider.dart
│   ├── mission_provider.dart
│   └── inventory_provider.dart
├── screens/                # Pantallas de la UI
│   ├── auth/
│   ├── home/
│   │   └── widgets/
│   ├── inventory/
│   └── profile/
├── scripts/                # Scripts utilitarios
│   └── seed_items.dart
└── utils/                  # Helpers
```

---

## Stack técnico

| Capa | Tecnología |
|------|-----------|
| **Frontend** | Flutter + Dart |
| **State Management** | Riverpod |
| **Backend** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth (email/password) |
| **Database** | PostgreSQL con RLS |
| **Animaciones** | Flutter Animate |

---

## Estado del proyecto

**✅ Backend completo**
- Auth (signup, login, logout)
- CRUD de hábitos, misiones e inventario
- Sistema de XP, niveles y oro
- 16 items en tienda (armas, armaduras, pociones, skins)

**🔄 En progreso — Frontend**
- [ ] Login / Signup
- [ ] Dashboard (héroe, daily quests, stats)
- [ ] Tienda y compras
- [ ] Inventario y equipamiento
- [ ] Perfil

---

## Contribuir

```bash
git checkout -b feature/tu-feature
# haz cambios
git commit -m "Add feature XYZ"
git push origin feature/tu-feature
# abre un Pull Request
```

---

**DailyHero** — RPG habit tracker hecho con ❤️ en Flutter.
