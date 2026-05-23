# Ink & Echo

**Tagline:** Your personal archive for the words that move you.

---

## What is Ink & Echo?

**Ink & Echo** is a Flutter mobile app for readers who want to remember *how* a book felt—not only *that* they read it. Many apps track titles and star ratings; Ink & Echo is a private journal for reflections, moods, cover photos, and spoken thoughts tied to each volume on your shelf.

After signing in, you build a personal **Vault** of book entries stored in the cloud. Each entry can include title and author, a written “echo” (your reflection or a favourite quote), an optional mood, a compressed cover photo, and a voice note saved as text via on-device speech recognition. The experience is calm and bookish—warm surfaces, Playfair Display headings, and a bento-style vault layout—so capturing a reading moment feels intentional rather than like filling in a spreadsheet.

---

## Main features

### Authentication & private data
- **Email/password** sign-in and sign-up, plus **Google** sign-in (platform-dependent).
- **Forgot password** flow via Firebase Auth.
- Each user’s data lives under their Firebase UID; there is no public feed or multi-user sharing.

### Vault (home)
- **Live library** of saved books from Cloud Firestore (`users/{uid}/books`).
- **Pull to refresh** on the vault list (and offline/error empty states) to retry sync via `BookService.retryConnection()`.
- **Bento layout**: featured card for the latest entry, scrollable entry cards, and a “Start a New Entry” prompt.
- **Menu drawer**: quick links to add a reflection, open Settings, and **sort** entries (newest, oldest, title A–Z).
- **Search**: filter entries by title, author, echo, mood, or transcription text.

### Add a reflection
- Form for **title**, **author**, **echo** (reflection/quote), and **mood** (preset chips).
- **Unsaved changes guard**: closing the form or using the system back gesture prompts to discard if you have edited fields without saving.
- **Photo**: camera or gallery via `image_picker`; cover is compressed and stored as **base64** in Firestore (no separate Storage bucket required).
- **Voice**: `speech_to_text` dictation; the **transcription** is saved as text with the entry (not an audio file).

### Entry detail
- Read a full entry: cover image, echo, transcription, mood, and metadata (**Added** date and **Last updated** after edits).
- **Edit** reopens the reflection form with existing data; **Delete** removes the entry after confirmation.

### Settings & accessibility
- Account summary and **sign out**.
- **Dark mode**, text size, bold text, high contrast, and reduce motion (persisted with `shared_preferences`).
- **Screen reader support:** descriptive labels on vault, reflection, and detail actions; TalkBack/VoiceOver announcements when an entry is saved or deleted (`lib/utils/a11y_announce.dart`).

### Assignment requirements (summary)

| Requirement | Implementation |
| :--- | :--- |
| User authentication | Firebase Auth (email/password, Google) |
| Remote database | Cloud Firestore per-user `books` subcollection |
| Mobile service (photo) | `image_picker` + compressed base64 cover on each entry |
| Mobile service (voice) | `speech_to_text` → `transcription` field on each entry |
| CRUD | **Create**, **Read**, **Update**, and **Delete** (edit/delete on entry detail screen) |
| Single-user privacy | Firestore paths scoped by `uid`; no shared collections |

---

## Users & personas

Ink & Echo is for **individual readers** who want a private, low-pressure place to capture reading memories—not for social discovery or publisher analytics.

### Persona A — The atmospheric reader
**Maya**, 28, reads mostly fiction on evenings and weekends. She finishes books she loves but forgets the exact lines or feelings weeks later. She uses Ink & Echo to log a mood (“Deeply Moving”), a short echo, and sometimes a cover photo so she can scroll the Vault and recall *why* a book mattered—without posting reviews publicly.

### Persona B — The student researcher
**Jordan**, 21, juggles course reading and personal books. They photograph cover art or jot dictated notes while commuting. They choose Ink & Echo over a generic notes app because entries are structured per book (title, author, tags) and stay synced in one private library instead of scattered folders.

### Persona C — The reflective journal keeper
**Sam**, 35, already keeps a paper journal but wants backup and search. They use **search** in the Vault to find an author or phrase, and **sort** to revisit oldest favourites. They value privacy (no followers) and accessibility options (dark mode, larger text).

### Why Ink & Echo over alternatives?
| Alternative | Limitation | Ink & Echo |
| :--- | :--- | :--- |
| Goodreads / StoryGraph | Focus on ratings, lists, social features | Focus on personal echo, mood, and media |
| Apple Notes / Google Keep | Unstructured, not book-centric | One card per book with consistent fields |
| Photo gallery | Images without reading context | Cover + reflection + voice transcription together |

---

## Technical details

### Stack
- **Flutter** (Dart 3.11+), Material 3 theming
- **Firebase Core**, **Firebase Auth**, **Cloud Firestore**
- **google_sign_in**, **image_picker**, **permission_handler**, **speech_to_text**, **image** (compression), **shared_preferences**, **google_fonts**

### Code documentation

Source files use **file-level comments** (purpose of the module), **`///` doc comments** on public classes and methods, and short notes on non-obvious logic (e.g. Firestore field deletes, image size limits, safe-area handling). See [`lib/CODE_OVERVIEW.md`](lib/CODE_OVERVIEW.md) for a one-page architecture map.

### Project structure

```
lib/
├── CODE_OVERVIEW.md          # Architecture map for markers
├── main.dart                 # Firebase init, theme, AuthGate
├── config/google_auth_config.dart
├── data/sample_vault_entries.dart
├── firebase_options.dart     # Generated by FlutterFire CLI
├── models/book.dart
├── pages/                    # login, vault, reflection, detail, settings, shell
├── services/                 # auth, book CRUD, accessibility prefs
├── theme/                    # tokens, typography, light/dark themes
├── utils/                    # image encoding, permissions, vault filter/sort
├── utils/a11y_announce.dart  # Screen reader announcements for save/delete
└── widgets/                  # nav bar, vault UI, brand, buttons
docs/sample_vault_entries.md  # Demo copy + cover image search terms
tool/seed_sample_entries.dart # Seed test account (dart run tool/...)
test/unit/ + test/widget/     # Run: flutter test
```

### Firestore data model
- Path: `users/{userId}/books/{bookId}`
- Fields: `title`, `author`, `echo`, `mood?`, `coverImageBase64?`, `transcription?`, `createdAt` (server timestamp on create), `updatedAt` (server timestamp on each update)
- **Offline support:** Firestore persistence (`lib/services/firestore_bootstrap.dart`) caches vault data locally. `connectivity_plus` drives offline/sync banners on the vault (`VaultSyncBanner`), a full-screen offline empty state with **Try again**, load-error retry (`BookService.retryConnection`), and **Retry** snackbars on save/delete in reflection and detail screens.

### Running the app

1. Install [Flutter](https://docs.flutter.dev/get-started/install) and a device emulator or physical device.
2. Create a Firebase project and enable **Authentication** (Email/Password + Google) and **Cloud Firestore**.
3. Configure the app (if not already done):
   ```bash
   flutter pub get
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. Run:
   ```bash
   flutter run
   ```
5. **Google sign-in (required on Android emulator):**
   - Firebase Console → **Authentication** → **Sign-in method** → enable **Google**.
   - Project settings → your **Android** app → add debug **SHA-1**:
     ```bash
     keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
     ```
   - Re-download `google-services.json` into `android/app/` (it should include `oauth_client` entries).
   - Copy the **Web client ID** (`….apps.googleusercontent.com`) into `lib/config/google_auth_config.dart` (`_defaultWebClientId`), or run with:
     ```bash
     flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
     ```

### Suggested Firestore security rules

Markers should confirm rules restrict access to the signed-in user:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/books/{bookId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Test account for markers

> **Important:** Replace the placeholders below with a real account you create in [Firebase Console → Authentication](https://console.firebase.google.com/) before submission. Markers need working credentials to sign in without using your personal email.

| Field | Value |
| :--- | :--- |
| **Email** | `test@gmail.com`|
| **Password** | `Test1234` |

**How to sign in**
1. Open the app → use **Sign in** with the table credentials, **or**
2. Tap **Sign up** once to register a new account (any valid email + password ≥ 6 characters). Data is isolated per account.

**Sample vault data** (5 demo entries + cover image search terms): see [docs/sample_vault_entries.md](docs/sample_vault_entries.md).  
Seed the test account:

```bash
flutter run -d emulator-5554 --target tool/seed_sample_entries.dart
```

**Google sign-in:** works on supported platforms when Google provider is enabled in Firebase; use email/password if Google is unavailable in the marking environment.

### Permissions
- **Camera / photos** — adding a cover image on the reflection screen.
- **Microphone / speech** — voice dictation (`speech_to_text`); denied permissions show an in-app message.

### Testing

Run the full suite:

```bash
flutter test
```

**Unit tests** (`test/unit/`): `Book`, `BookService` (CRUD + signed-out errors), `book_format`, vault filter/sort, image encoding, `AuthService` error mapping, `AccessibilitySettings`, `media_permissions` (mocked platform), `GoogleAuthConfig`, and sample seed data.

**Widget tests** (`test/widget/`): login validation, vault list/search/navigation (injected `BookService`), reflection create/edit/save, book detail edit/delete confirmation, drawer, bento cards, settings, main shell, and common buttons. Shared helpers in `test/helpers/test_helpers.dart` (`createSeededBookService`, fake permissions).

**97 tests** — run `flutter test` (all should pass).

---

## Information for markers

### What to evaluate
1. **Sign-in** — email/password (and Google if configured).
2. **Create** — menu or “Start a New Entry” → Add reflection → save with title + author; optional photo, mood, voice transcription.
3. **Read** — entries appear in the Vault; tap for detail view (check **Added** / **Last updated** after editing).
4. **Pull to refresh** — on the Vault, pull down to retry sync when offline or after errors.
5. **Search & sort** — Vault app bar search; drawer sort options.
6. **Unsaved guard** — start a new reflection, type a title, tap close; confirm discard dialog appears.
7. **Settings** — accessibility toggles and sign out.
8. **Screen readers** — enable TalkBack (Android) or VoiceOver (iOS); confirm icon buttons are announced clearly and save/delete are spoken aloud.
9. **Privacy** — second account should not see the first account’s books (separate Firebase users).

### Known limitations (honest scope)
- **Edit** opens the same form as “Add reflection”; there is no inline edit on the vault list itself.
- Voice is stored as **transcription text**, not playable audio files.
- Cover images are stored as **base64 in Firestore** (size-capped); Firebase Storage is not used.

### Platform notes
- Tested target: **iOS / Android** (primary). Web may require extra Firebase/Google configuration.
- Firebase config is in `lib/firebase_options.dart` (project-specific; do not commit private keys outside what FlutterFire generates).

### Contact
Name: Minh Vy Ha
Student ID: 48485837
Contact Email: minhvy.ha@students.mq.edu.au

---

*Ink & Echo — built with Flutter & Firebase.*
