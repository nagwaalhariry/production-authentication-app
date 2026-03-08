# Production Authentication App (Flutter)

This project uses clean architecture + BLoC with a feature-first structure.

## Current Auth Backend

Firebase integration has been fully removed.

The app now uses a local in-memory auth data source for:

- Signup / Login / Logout
- Email verification state simulation
- Role-based access (`admin` / `user`)
- Device binding checks
- Token refresh simulation

## Architecture

- `lib/core`: shared app utilities (errors, failures, use case base, observer)
- `lib/features/auth/domain`: entities, repository contracts, use cases
- `lib/features/auth/data`: local datasource + repository implementation
- `lib/features/auth/presentation`: BLoC + pages

## Notes

- Accounts are not persisted across app restarts (in-memory only).
- `sendEmailVerification` is simulated and marks the current account as verified.
- TODO: Replace local datasource with real backend when needed.

## Run

```bash
flutter pub get
flutter run
```
