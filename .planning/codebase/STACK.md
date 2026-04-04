# Technology Stack

## Core Framework
- **Flutter**: Cross-platform UI toolkit.
- **Dart SDK**: `^2.17.5` (Compatibility for `<3.0.0`).

## Platform Configurations
- **Android**:
  - `compileSdkVersion`: 36
  - `targetSdkVersion`: 36
  - `minSdkVersion`: Flutter default
  - Namespace: `com.tsinfosec.ebook.ebook`
- **iOS**: Flutter-based integration with `app_links` and social login.

## Main Dependencies
- **State Management**: `provider` (^6.1.2) - Uses `MultiProvider` at the root.
- **Networking**: `dio` (^5.2.1+1) - Service layer likely centered around `lib/Networking/api_provider.dart`.
- **UI & Layout**:
  - `sizer`: Responsive sizing.
  - `google_fonts`: Custom typography (SF Pro Display).
  - `cached_network_image`: Image caching.
  - `shimmer`: Loading states.
  - `lottie`: Vector animations.
  - `carousel_slider`: Image carousels.
- **Local Storage**:
  - `shared_preferences`: Simple key-value storage.
  - `flutter_secure_storage`: Encrypted storage for sensitive data.
  - `path_provider`: Access to filesystem paths.

## Development Tools
- **Linting**: `flutter_lints` (^6.0.0).
- **Internationalization**: `flutter_localization` (^0.3.2).
