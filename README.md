# DailyHero

RPG habit tracker desarrollado en Flutter. Transforma tus hábitos en misiones épicas.

## Setup inicial

1. **Instala Flutter** (si no lo tienes)
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
   - Pide las credenciales de Supabase (SUPABASE_URL y SUPABASE_ANON_KEY)
   - Crea archivo `.env` en raíz con esas credenciales

5. **Corre el app**
```bash
   flutter run -d chrome  # Para web
   # O flutter run para Android/iOS
```

## Estructura del proyecto
lib/
├── main.dart                 # Entry point
├── config/theme.dart        # Colores, tipografía
├── models/                  # Estructuras de datos
├── services/                # Lógica Supabase
├── providers/               # State management Riverpod
├── screens/                 # UI
└── utils/

## Stack técnico

- **Frontend**: Flutter + Riverpod
- **Backend**: Supabase (Auth, Postgres, RLS)
- **State**: Riverpod
- **Database**: PostgreSQL

## Status del proyecto

✅ Backend completo
  - Auth (login/signup)
  - CRUD Habits, Missions, Inventory
  - Sistema XP y oro
  - Items seeded (16 items en tienda)

🔄 En progreso: Frontend
  - Dashboard
  - Auth screens
  - Habit management
  - Shop

## Contribuir

1. Crea un branch: `git checkout -b feature/tu-feature`
2. Haz cambios
3. Commit: `git commit -m "Add feature XYZ"`
4. Push: `git push origin feature/tu-feature`
5. Abre PR
