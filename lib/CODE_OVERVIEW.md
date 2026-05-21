# Ink & Echo — code map

This file complements in-code `///` comments for assignment markers reviewing structure.

## Entry and auth

| File | Role |
|------|------|
| `main.dart` | Firebase init, theme, `MaterialApp` → `AuthGate` |
| `services/auth_gate.dart` | Shows `LoginPage` or `MainShell` from auth state |
| `services/auth_service.dart` | Email/password + Google sign-in |
| `config/google_auth_config.dart` | Web OAuth client ID for mobile Google Sign-In |

## Signed-in UI

| File | Role |
|------|------|
| `pages/main_shell.dart` | Bottom nav + `IndexedStack` (Vault, Settings) |
| `pages/vault_page.dart` | Stream list, search, drawer, navigation to detail/add |
| `pages/reflection_page.dart` | Create/update entry form (CRUD write path) |
| `pages/book_detail_page.dart` | Read entry; edit/delete |
| `pages/settings_page.dart` | Accessibility prefs + logout |

## Data layer

| File | Role |
|------|------|
| `models/book.dart` | Domain model + Firestore serialization |
| `services/book_service.dart` | `watchBooks`, `saveBook`, `updateBook`, `deleteBook` |

Firestore path: `users/{uid}/books/{bookId}`.

## Widgets and utils

- `widgets/vault/` — app bar, drawer, bento cards
- `widgets/ink_echo_brand.dart` — shared wordmark
- `utils/vault_book_list.dart` — client search/sort
- `utils/book_format.dart` — card display helpers
- `utils/image_base64_encoder.dart` — cover compression for Firestore

## Tests

`test/unit/` — models and services; `test/widget/` — pages and widgets. Run: `flutter test`.
