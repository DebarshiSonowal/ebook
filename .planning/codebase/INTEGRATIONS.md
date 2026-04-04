# External Integrations

## Core Services
- **Firebase**:
  - `firebase_core`: Central initialization.
  - `firebase_auth`: User authentication.
  - Options: `firebase_options.dart` (Platform-specific configurations).

## Payment Gateways
- **Razorpay**: Used for primary payment processing via `razorpay_flutter`.
- **Pay**: Integration for Apple Pay and Google Pay (`pay` package).

## Social Login
- **Google Sign-In**: `google_sign_in` (^7.2.0), `initialization` in `main.dart`.
- **Apple Sign-In**: `sign_in_with_apple` (^7.0.1).

## Deep Linking
- **App Links**: `app_links` (^6.4.0).
- Handled extensively in `main.dart` with custom routing logic to handle formats like:
  - `tratri.in/link?format=...&id=...`
  - `tratri://` custom scheme.
  - Facebook fallback formats.
- Supports debouncing and deep link state persistence in `Storage`.

## Utilities & SDKs
- **Connectivity**: `connectivity_plus` for monitoring network status.
- **App Updates**: `upgrader` for managing application version updates.
- **Animations**: `lottie` for interactive SVG/JSON animations.
- **Sharing**: `share_plus` for content sharing.
