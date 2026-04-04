# Application Architecture

## Architecture Pattern
- **Provider-based State Management**: The application uses the `provider` package to manage state across the app. Root widgets are wrapped in `MultiProvider` in `main.dart`.
- **Layered approach**:
  - **Networking Layer**: `lib/Networking/api_provider.dart` handles external HTTP requests using `Dio`.
  - **Data/Storage Layer**: `lib/Storage/` manages both in-memory state (`DataProvider`, `CommonProvider`) and persistent storage (`Storage` class).
  - **UI Layer**: Segregated into `Routes/` (pages) and `Components/` (reusable UI elements).

## Root Components
- **main.dart**: Central point of entry. Handles initialization of Firebase, Storage, and Google Sign-In. Contains robust deep linking logic with `app_links`.
- **MaterialApp**: Configured with a `navigatorKey` for global navigation assistance and `onGenerateRoute` for dynamic routing.

## Routing & Navigation
- **Routing**: Centralized in `lib/Helper/router.dart` using a switch/case logic for named routes.
- **Navigation**: Controlled by `lib/Helper/navigator.dart`, providing a singleton `Navigation` class to handle common transitions (push, replace, pop).

## State Flow
1. **API Call**: Triggered by user action or page load via `ApiProvider`.
2. **Model Parsing**: JSON results mapped to classes in `lib/Model/`.
3. **Provider Update**: Data cached/stored in `DataProvider`.
4. **UI Rebuild**: UI components listening to the provider update automatically.
