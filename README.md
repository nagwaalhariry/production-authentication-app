# Production Authentication App (Flutter + Firebase)

A production-oriented authentication module built with Flutter using **clean architecture**, **feature-first structure**, **BLoC state management**, and **repository pattern**.

## Features

- Firebase Authentication with Email/Password
- Login / Signup / Logout
- Email verification flow (send verification + refresh verification status)
- Role-based access (`admin` / `user`)
- Device binding via serial number stored in Firestore
- Token refresh handling (`getIdToken(true)`)
- Global error handling (`runZonedGuarded`, `FlutterError`, `BlocObserver`)
- Explicit loading/success/failure UI states
- Unit test example for login use case

## Architecture Decisions

### Why Clean Architecture

- **Independence from frameworks**: business rules are isolated in `domain`.
- **Testability**: use cases and repositories are easy to mock/test.
- **Scalability**: auth can grow (MFA, OAuth, refresh policies, security events) without tight coupling.

### Why Feature-First Structure

The project is organized by feature so auth code remains cohesive and maintainable:

- `lib/features/auth/data`: Firebase/Firestore integrations and repository implementation.
- `lib/features/auth/domain`: entities, repository contracts, and use cases.
- `lib/features/auth/presentation`: BLoC + UI screens.
- `lib/core`: shared abstractions (errors, failures, use case base, app-level observer).

### Why BLoC

BLoC provides:

- deterministic state transitions,
- explicit side-effect boundaries,
- traceability for production debugging,
- easy integration with global observers.

## Project Structure

```text
lib/
  core/
    app_bloc_observer.dart
    error/
      exceptions.dart
      failures.dart
    network/
      network_info.dart
    state/
      request_status.dart
    usecase/
      usecase.dart
  features/
    auth/
      data/
        datasources/
          auth_remote_data_source.dart
          device_info_data_source.dart
        models/
          user_model.dart
        repositories/
          auth_repository_impl.dart
      domain/
        entities/
          app_user.dart
        repositories/
          auth_repository.dart
        usecases/
          login_usecase.dart
          signup_usecase.dart
          logout_usecase.dart
          send_email_verification_usecase.dart
          check_email_verified_usecase.dart
      presentation/
        bloc/
          auth_bloc.dart
          auth_event.dart
          auth_state.dart
        pages/
          auth_gate_page.dart
          login_page.dart
          signup_page.dart
          home_page.dart
```

## Auth + Security Flow

1. User logs in with Firebase email/password.
2. Token is force-refreshed (`getIdToken(true)`) to avoid stale claims/session.
3. App fetches Firestore profile (`users/{uid}`).
4. Device serial validation:
   - If profile has no serial -> bind current device.
   - If serial differs -> deny access (`DeviceBindingException`).
5. Role validation:
   - Accept only `admin` or `user`.
   - Any other role is rejected (`UnauthorizedRoleException`).
6. Email verification state is exposed in UI and can be rechecked after user verifies.

## Firestore Schema

Collection: `users`

Example document (`users/{uid}`):

```json
{
  "email": "user@example.com",
  "role": "user",
  "deviceSerial": "brand-model-id",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

## Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure Firebase:
   - Create Firebase project.
   - Enable Email/Password auth.
   - Add Firestore database.
   - Run:
     ```bash
     flutterfire configure
     ```
   - Wire generated options in `main.dart`.

3. Run app:
   ```bash
   flutter run
   ```

## Edge Cases Handled

- Invalid email/password
- Disabled accounts
- Too many login attempts
- Expired token/session
- Network failures
- Missing user profile (auto-seeding)
- Unauthorized role values
- Device mismatch and initial device binding

## TODOs for Production Hardening

- TODO: Add secure device attestation (Play Integrity / DeviceCheck) instead of soft serial only.
- TODO: Add server-side verification with Cloud Functions before granting privileged actions.
- TODO: Add refresh-token/session revocation handling and forced logout strategy.
- TODO: Add remote logging/monitoring (Crashlytics/Sentry + structured analytics events).
- TODO: Add widget/integration tests for full auth state transitions.
- TODO: Add password reset and optional MFA.

## Testing

Run tests:

```bash
flutter test
```

Included example:

- `test/features/auth/domain/usecases/login_usecase_test.dart`
