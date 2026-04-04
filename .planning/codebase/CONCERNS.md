# Codebase Concerns & Technical Debt

## High-Level Concerns
- **SDK Obsolescence**: The project enforces a Dart SDK `<3.0.0`. This restricts the use of major language features like Records and Pattern Matching, and limits access to the latest Flutter improvements.
- **Deep Link Maintainability**: `lib/main.dart` contains over 500 lines of manual URI parsing, routing, and debouncing logic. This is error-prone and should ideally be abstracted into a dedicated Service or using a package like `go_router`.
- **Testing Coverage**: As of now, there is essentially no test coverage beyond the default widget test. This increases the risk of regressions during refactoring.

## Technical Debt & TODOs
- **Modularization**: Feature screens (Routes) are somewhat monolithic. Several core pages like `book_details.dart`, `library_details_screen.dart`, and `magazine_details.dart` contain pending `TODO` comments.
- **State Management Complexity**: While `Provider` is implemented, there are many manual rebuild triggers and potential for state leakage or synchronization issues.

## Dependencies & Infrastructure
- **Dependency Ranges**: Many packages in `pubspec.yaml` have wide version ranges or are commented out, suggesting some configuration instability or remnants of previous development efforts.
- **Asset Management**: A large number of images and animations are stored in a flat `assets/` structure, which may become disorganized as the project grows.

## Actionable Recommendations
1. **Upgrade**: Move to Dart 3.0+ to leverage modern language features.
2. **Refactor**: Extract deep link logic from `main.dart` into a centralized `DeepLinkService`.
3. **Automate**: Implement unit tests for key networking and data handling logic.
