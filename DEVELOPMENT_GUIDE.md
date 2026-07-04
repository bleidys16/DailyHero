# DailyHero - Guía de Desarrollo

## 📖 Contexto de la App

**DailyHero** es un rastreador de hábitos para móviles (Flutter) que transforma tu rutina diaria en un videojuego RPG estilo pixel art.

**Concepto clave**: Tu avatar gana experiencia (XP) y oro cuando cumples hábitos en la vida real (estudiar, ejercicio, etc.). Si fallas tus tareas, tu personaje pierde HP. Con el oro ganado, puedes equipar tu héroe en la tienda.

**Plataforma**: Flutter (iOS, Android, Web)  
**Backend**: Supabase (PostgreSQL + Auth)  
**State Management**: Riverpod  
**Tema Visual**: Pixel art RPG estilo retro

---

## 🛠️ Stack Técnico

| Capa | Tecnología |
|------|-----------|
| **Frontend** | Flutter + Dart |
| **UI Components** | Flutter widgets + Riverpod |
| **State Management** | Riverpod (FutureProvider, StateNotifier) |
| **Backend** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth (Email/Password) |
| **Database** | PostgreSQL con RLS |
| **Animaciones** | Flutter Animate, Custom Painters |

---

## ✅ Fase 1: Backend (COMPLETA)

### Lo que se hizo

#### Models (lib/models/)
- ✅ `user.dart` - Entidad usuario con stats (level, XP, HP, oro, streak)
- ✅ `habit.dart` - Hábitos con frecuencia (diario/semanal/único), dificultad (easy/medium/hard), categoría, XP variable
- ✅ `mission.dart` - Misiones (pendiente/completada/fallida) vinculadas a hábitos
- ✅ `inventory.dart` - Items (armas, armaduras, pociones, cosméticos) con rareza (common/uncommon/rare/legendary)

#### Supabase Service (lib/services/supabase_service.dart)
- ✅ Auth: signup, login, logout, getCurrentUser
- ✅ Users: CRUD completo + addXp + addGold + spendGold
- ✅ Habits: crear, listar, completar, actualizar, eliminar
- ✅ Missions: crear, listar, completar
- ✅ Inventory: listar, comprar items, equipar/desequipar

#### Riverpod Providers (lib/providers/)
- ✅ `user_provider.dart` - Gestión de usuario y stats (login, logout, addXp, addGold)
- ✅ `habit_provider.dart` - CRUD de hábitos y lista diaria
- ✅ `mission_provider.dart` - Gestión de misiones
- ✅ `inventory_provider.dart` - Compras y equipamiento

#### Supabase Database
- ✅ Tablas: `users`, `habits`, `missions`, `items`, `inventory`
- ✅ RLS (Row Level Security) configurada
- ✅ Relaciones con CASCADE delete
- ✅ 16 items seeded (4 armas, 4 armaduras, 4 pociones, 4 skins)

### Scripts ejecutados
```sql
-- Tablas creadas
-- RLS habilitado
-- Items insertados
```

### Próximo paso
→ Pasar a **Fase 2: Auth UI**

---

## 🔄 Fase 2: Auth UI (EN PROGRESO)

### Pantallas a desarrollar

#### 2.1 Login Screen
**Path**: `lib/screens/auth/login_screen.dart`

**Features**:
- Campo email (validación)
- Campo password (ocultar/mostrar)
- Botón "Entrar"
- Link "¿No tienes cuenta? Regístrate"
- Indicador de carga
- Mensajes de error

**Connexiones**:
- `userNotifierProvider.login()`
- Navegar a Dashboard si éxito

**UI Reference**: Colores oscuros (1E293B), botones púrpura (7C3AED), acentos cyan

**Tiempo estimado**: 2-3 horas

---

#### 2.2 Signup Screen
**Path**: `lib/screens/auth/signup_screen.dart`

**Features**:
- Campo nombre
- Campo email (validación)
- Campo password (validación: mín 6 chars)
- Confirmar password
- Botón "Crear Cuenta"
- Link "¿Ya tienes cuenta? Inicia sesión"
- Indicador de carga
- Mensajes de error

**Validaciones**:
- Email formato válido
- Password ≥ 6 caracteres
- Passwords coinciden

**Conexiones**:
- `userNotifierProvider.signUp()`
- Navegar a Dashboard si éxito

**Tiempo estimado**: 2-3 horas

---

### Ruta de navegación actual
App Start
↓
¿Usuario autenticado? (verificar currentUserProvider)
├─ NO → Login Screen
│        ├─ ¿Sin cuenta? → Signup Screen
│        └─ Login exitoso → Dashboard
│
└─ SÍ → Dashboard

### Entregables
- [ ] Login screen funcional
- [ ] Signup screen funcional
- [ ] Navegación auth completa
- [ ] Validación de campos
- [ ] Manejo de errores
- [ ] Indicadores de carga

---

## 🎮 Fase 3: Dashboard Principal (PRÓXIMO)

### Pantalla principal después de login

**Path**: `lib/screens/home/dashboard_screen.dart`

#### 3.1 Hero Card (Widget)
**Path**: `lib/screens/home/widgets/hero_card.dart`

Muestra:
- Avatar pixel art (placeholder por ahora)
- Nombre del usuario
- Nivel actual
- Barra de HP (color rojo/verde)
- Barra de XP (color amarillo, mostrando progreso al siguiente nivel)
- Oro actual (icon + cantidad)

**Data source**: `userNotifierProvider`

---

#### 3.2 Daily Quests / Misiones del Día
**Path**: `lib/screens/home/widgets/daily_quests.dart`

Muestra lista de hábitos diarios sin completar:
- Checkbox para marcar como completo
- Nombre del hábito
- Categoría (con icon)
- Dificultad (easy/medium/hard)
- XP que se ganará al completar
- Animación al completar (confetti opcional)

**Data source**: `dailyHabitsProvider`

---

#### 3.3 Stats & Progress
**Path**: `lib/screens/home/widgets/stats_bar.dart`

Muestra:
- Racha de días (streak)
- Total de hábitos completados esta semana
- Categoría más trabajada

---

### Layout del Dashboard
┌─────────────────────────────┐
│   HERO CARD                 │
│  [Avatar] Nombre            │
│  Nivel 14 | HP [===] | 850 XP
│  �� 2400 oro                │
└─────────────────────────────┘
┌─────────────────────────────┐
│   DAILY QUESTS              │
│ ☐ Ir al gimnasio 1 hora     │
│   💪 Medium | +150 XP       │
│                             │
│ ☐ Estudiar 2 horas          │
│   🧠 Hard | +200 XP         │
│                             │
│ ☑ Meditar 10 min  [DONE]    │
│   🕉️  Easy | +50 XP         │
└─────────────────────────────┘
┌─────────────────────────────┐
│   STATS                     │
│ 🔥 Racha: 7 días           │
│ 📊 Esta semana: 12 hábitos  │
│ 🏆 Top categoría: Salud     │
└─────────────────────────────┘

### Interacciones
- Tap en checkbox → completa hábito, suma XP/oro
- Swipe en quest → eliminar (con confirmación)
- Tap en hero → ir a pantalla de perfil/stats detallado
- Swipe down → refrescar datos

### Tiempo estimado
- Hero Card: 1.5 horas
- Daily Quests: 2 horas
- Stats: 1 hora
- Layout + Navegación: 1 hora

---

## 🏪 Fase 4: Tienda (SHOP)

**Path**: `lib/screens/inventory/shop_screen.dart`

### Features
- Listar los 16 items disponibles
- Filtrar por tipo (armas, armaduras, pociones, skins)
- Mostrar rareza con colores
- Precio en oro
- Botón "Comprar" (si tienes oro)
- Mostrar items ya comprados en inventario
- Animación al comprar

### Layout
┌─────────────────────┐
│ TIENDA              │
│ 💰 Tu oro: 2400     │
│                     │
│ Filtros:            │
│ [All] [⚔️] [🛡️] [🧪] [👑]
│                     │
│ ⚔️ Espada Éxito     │
│    💎 Rare          │
│    Costo: 2500      │
│    [Comprar]        │
│                     │
│ 🧪 Poción Vitalidad│
│    Uncommon         │
│    Costo: 300       │
│    [Comprar]        │
└─────────────────────┘

### Tiempo estimado: 2-3 horas

---

## 📊 Fase 5: Inventario & Equipamiento

**Path**: `lib/screens/inventory/inventory_screen.dart`

### Features
- Mostrar items poseídos
- Equipar/desequipar items
- Ver descripción y bonus
- Gestión de cantidad (pociones)

### Tiempo estimado: 1.5 horas

---

## 👤 Fase 6: Perfil & Leaderboard

### 6.1 Profile Screen
**Path**: `lib/screens/profile/profile_screen.dart`

Muestra:
- Nombre, email
- Stats detallados (total XP, racha actual, etc.)
- Historial de hábitos completados
- Items equipados
- Botón logout

**Tiempo**: 2 horas

### 6.2 Leaderboard (Opcional)
Mostrar ranking de usuarios por XP/nivel.

**Tiempo**: 2 horas

---

## 🎨 Fase 7: Pulido & Animaciones (FINAL)

### Features
- Animaciones al ganar XP
- Transiciones de pantallas
- Efectos visuales al completar quests
- Sonidos (opcional)
- Tema oscuro/claro toggle
- Offline support (caché local)

### Tiempo estimado: 3-4 horas

---

## 📱 Fase 8: Testing & Deployment (FUTURE)

- Tests unitarios (models, providers)
- Tests de integración (Supabase)
- Tests de UI
- Build APK / IPA
- Deploy a Play Store / App Store
- Beta testing

---

## 🗓️ Cronograma Estimado

| Fase | Status | Tiempo Est. | Prioridad |
|------|--------|-------------|-----------|
| 1. Backend | ✅ DONE | N/A | 🔴 |
| 2. Auth UI | 🔄 IN PROGRESS | 4-6h | 🔴 |
| 3. Dashboard | ⏳ NEXT | 5-6h | 🔴 |
| 4. Shop | ⏳ PENDING | 2-3h | 🟠 |
| 5. Inventory | ⏳ PENDING | 1.5h | 🟠 |
| 6. Profile | ⏳ PENDING | 2h | 🟡 |
| 7. Animations | ⏳ PENDING | 3-4h | 🟡 |
| 8. Testing & Deploy | ⏳ FUTURE | Variable | 🟡 |

**Total estimado**: 20-25 horas

---

## 🎯 Checklist de Desarrollo

### Fase 2 (Auth)
- [ ] Login screen funcional
- [ ] Signup screen funcional
- [ ] Validaciones de campos
- [ ] Navegación después de auth
- [ ] Manejo de errores y loading states
- [ ] Tests básicos

### Fase 3 (Dashboard)
- [ ] Hero card con stats
- [ ] Daily quests list
- [ ] Checkbox para completar
- [ ] Stats visualization
- [ ] Refresh data
- [ ] Navegación a otras pantallas

### Fase 4 (Shop)
- [ ] Listar items
- [ ] Filtrar por tipo
- [ ] Sistema de compra
- [ ] Validar oro
- [ ] Actualizar inventario

### Fase 5+ (Completar)
- [ ] Inventario y equipamiento
- [ ] Pantalla de perfil
- [ ] Leaderboard (opcional)
- [ ] Animaciones y pulido

---

## 📝 Convenciones de Código

### Estructura de archivos
lib/
├── config/           # Tema, constantes
├── models/           # Entidades de datos
├── services/         # Lógica de Supabase
├── providers/        # State management
├── screens/          # UI / Pantallas
│   ├── auth/
│   ├── home/
│   │   └── widgets/
│   ├── inventory/
│   └── profile/
└── utils/            # Helpers

### Naming conventions
- **Archivos**: `snake_case.dart`
- **Clases**: `PascalCase`
- **Variables/Métodos**: `camelCase`
- **Constantes**: `UPPER_SNAKE_CASE`

### Commits
[FEATURE] Descripción de la feature
[FIX] Descripción del bug
[REFACTOR] Cambios de estructura
[DOCS] Actualizaciones de documentación

---

## 🤝 Roles & Asignación

- **Backend**: ✅ Completo
- **Frontend**: 🔄 Dos personas idealmente
  - Persona 1: Auth + Dashboard
  - Persona 2: Shop + Inventory + Perfil

---

## 📞 Troubleshooting

### "No puedo loguearme"
- Verifica credenciales de Supabase en `.env`
- Revisa que el usuario existe en tabla `auth.users`

### "Error de XP/oro no se actualiza"
- Verifica que RLS esté habilitado
- Checa que el usuario está autenticado

### "Pantalla se ve extraña"
- Limpia: `flutter clean && flutter pub get`
- Reconstruye: `flutter run`

---

## 📚 Referencias Útiles

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Supabase Flutter](https://supabase.com/docs/reference/dart)
- [Material Design 3](https://m3.material.io)

---

## ❓ Preguntas Frecuentes

**P: ¿Puedo trabajar en diferentes fases al mismo tiempo?**  
R: Sí, pero asegúrate de que no haya conflictos en git. Usa branches separados.

**P: ¿Necesito crear los items manualmente?**  
R: No, ya están seeded en la BD (script Dart ejecutado).

**P: ¿Cómo testeo si todo funciona?**  
R: `flutter run -d chrome` y prueba en vivo.

---

## 🚀 Próximos pasos

1. Terminar Fase 2 (Auth UI)
2. Pasar a Fase 3 (Dashboard)
3. Implementar tienda y inventario
4. Pulir animaciones
5. Deploy

---

**Última actualización**: Julio 2026  
**Estado**: Backend completo, Frontend en progreso
