# 🛍️ Ecommerce App

A Flutter e-commerce app built with **BLoC** state management, clean feature-based architecture, and a premium dark/light theme system.

---

## 🗂️ Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   ├── storage/
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── theme_cubit.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── services/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── services/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── favorites/
│       ├── data/
│       │   └── repositories/
│       └── presentation/
│           ├── bloc/
│           └── pages/
│
└── shared/
    ├── routes/
    └── widgets/
```

---

## 🧠 BLoC Architecture

```
UI (Page/Widget)
    │
    │  dispatches Event
    ▼
  Bloc
    │  calls
    ▼
Repository
    │  calls
    ▼
Service (API / Hive)
    │
    ▼
  State  ──► UI rebuilds via BlocBuilder
```

### BLoCs

| BLoC | Events | States | Purpose |
|---|---|---|---|
| `AuthBloc` | `LoginRequested` | `initial`, `loading`, `success`, `failure` | Login flow |
| `HomeBloc` | `FetchProducts` | `initial`, `loading`, `loaded`, `error` | Load product list |
| `FavoritesBloc` | `LoadFavorites`, `ToggleFavorite` | `initial`, `loaded` | Manage favorites |
| `ThemeCubit` | `toggleTheme()` | `ThemeMode` | Light/dark mode |

States are immutable, generated with `freezed`, and pattern-matched in the UI via `state.when(...)`.

---

## 🎨 Theme System

- `AppColors` — color palette for light and dark modes
- `AppTheme` — builds `ThemeData` from `AppColors`
- `ThemeCubit` — toggles mode and persists it to Hive
- `app.dart` — `BlocBuilder<ThemeCubit, ThemeMode>` rebuilds the app on every toggle

---

## 🚀 Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
