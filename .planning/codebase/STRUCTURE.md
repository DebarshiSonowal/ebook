# Project Structure

## Directory Overview
The codebase follows a standard Flutter structure within the `lib/` directory:

- **Constants/**:
  - Global app constants (Static strings, `theme_data.dart`, colors).
- **Helper/**:
  - Utility classes for foundational logic (`router.dart`, `navigator.dart`).
- **Model/**:
  - Data classes and serialization models for the application.
- **Networking/**:
  - External API interaction modules (`api_provider.dart`).
- **Storage/**:
  - Data management and local storage abstraction (`app_storage.dart`, `data_provider.dart`, `common_provider.dart`).
- **UI/**:
  - **Components/**: Reusable UI widgets and custom elements.
  - **Routes/**: Dedicated screens and navigation pages (Subdivided into feature areas like `Auth/`, `Drawer/`, `Navigation Page/`, `OnBoarding/`).
- **Utility/**:
  - Reusable extensions and helper categories (e.g., `ip_utility.dart`, `ads_popup.dart`, `image_extension.dart`).

## Key Files
- **lib/main.dart**: Initial application configuration and entry point.
- **lib/firebase_options.dart**: Configuration file for Firebase.
- **pubspec.yaml**: Package dependencies and asset management.
- **analysis_options.yaml**: Linting rules and compiler configurations.
