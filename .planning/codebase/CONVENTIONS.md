# Coding Conventions

## Static Analysis
- **Linting**: The project uses `package:flutter_lints/flutter.yaml` as the base set of rules (Refer to `analysis_options.yaml`).
- **Standard rules**:
  - Consistent use of `const` constructors where possible.
  - Required imports grouped together.
  - Avoidance of unused variables and imports.

## Naming Conventions
- **Classes & Types**: PascalCase (e.g., `DataProvider`, `ApiProvider`).
- **Variables & Methods**: camelCase (e.g., `currentTab`, `initializeStorage`).
- **File naming**: snake_case for all `.dart` files (e.g., `api_provider.dart`, `main.dart`).

## Layout and Styling
- **Responsive Sizing**: The app relies heavily on the `sizer` package for adaptive layouts.
- **Theme Management**: App-wide styling is centralized in `lib/Constants/theme_data.dart` and accessed through `Theme.of(context)`.

## Error Handling
- **API Requests**: Network calls are encapsulated in `try/catch` blocks within the `ApiProvider`.
- **UI feedback**: Use of `fluttertoast` for displaying transient feedback to the user.
