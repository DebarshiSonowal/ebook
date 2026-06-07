# Requirements: ebook Refactoring

**Defined:** 2026-04-04
**Core Value:** Maintainability: Decoupling complex logic from the application entry point and modularizing the service layer.

## v1 Requirements

### Infrastructure & SDK
- [ ] **INFRA-01**: Upgrade Dart SDK constraint to `^3.0.0` in `pubspec.yaml`.
- [ ] **INFRA-02**: Update dependencies to versions compatible with Flutter 3.10+ and Dart 3.0.
- [ ] **INFRA-03**: Ensure project passes `flutter analyze` with updated SDK.

### Networking (NET)
- [ ] **NET-01**: Implement `BaseApiService` to centralize Dio configuration (base URL, timeouts, headers).
- [ ] **NET-02**: Implement global error handling and request/response logging via Interceptors.
- [ ] **NET-03**: Decouple `AuthService` from `ApiProvider` (login, logout, social login).
- [ ] **NET-04**: Decouple `BookService` from `ApiProvider` (fetching books, chapters, categories).
- [ ] **NET-05**: Decouple `LibraryService` from `ApiProvider` (library search, plans, reviews).
- [ ] **NET-06**: Ensure all extracted services inherit from `BaseApiService`.

### Initialization & Deep Linking (INIT)
- [ ] **INIT-01**: Create `DeepLinkService` to encapsulate all URI parsing logic currently in `main.dart`.
- [ ] **INIT-02**: Migrate debouncing and state management for deep links from `main.dart` to `DeepLinkService`.
- [ ] **INIT-03**: Refactor `main.dart` to use `DeepLinkService` for all incoming links.
- [ ] **INIT-04**: Verify deep link navigation flows (library, book info, reading page) are preserved.
- [ ] **INIT-05**: Configure iOS Universal Link entitlements and Info.plist for Facebook compatibility.
- [ ] **INIT-06**: Provide verified `apple-app-site-association` (AASA) content for server deployment.

## v2 Requirements (Deferred)
- **STATE-01**: Full migration of `DataProvider` and `CommonProvider` to a more modular state management pattern if needed.
- **TEST-01**: Comprehensive unit test suite for all new services.
- **UI-01**: Consolidation of duplicated UI components across different routes.

## Out of Scope
| Feature | Reason |
|---------|--------|
| New Features | Focus is strictly on refactoring and technical debt. |
| Riverpod/Bloc | Migration is out of scope; staying with Provider. |
| UI Redesign | No visual changes planned for this milestone. |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| INFRA-01 | Phase 1 | Pending |
| INFRA-02 | Phase 1 | Pending |
| INFRA-03 | Phase 1 | Pending |
| NET-01 | Phase 2 | Pending |
| NET-02 | Phase 2 | Pending |
| NET-03 | Phase 3 | Pending |
| NET-04 | Phase 4 | Pending |
| NET-05 | Phase 4 | Pending |
| NET-06 | Phase 3/4 | Pending |
| INIT-01 | Phase 5 | Pending |
| INIT-02 | Phase 5 | Pending |
| INIT-03 | Phase 5 | Pending |
| INIT-04 | Phase 5 | Pending |
| INIT-05 | Phase 1.1 | Pending |
| INIT-06 | Phase 1.1 | Pending |

**Coverage:**
- v1 requirements: 13 total
- Mapped to phases: 13
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-04*
*Last updated: 2026-04-04 after initial definition*
