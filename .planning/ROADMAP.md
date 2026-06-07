# Roadmap: ebook Refactoring

## Overview
This roadmap outlines the journey from a monolithic initialization and networking structure to a modular, service-oriented architecture. We will modernize the SDK, decouple complex logic, and improve the overall maintainability of the `ebook` project.

## Phases

- [ ] **Phase 1: SDK & Infrastructure Modernization** - Upgrade to Dart 3.0 and refresh project dependencies.
- [ ] **Phase 1.1: iOS Deep Link Priority Fix (INSERTED)** - Resolve iOS redirection to App Store from Facebook.
- [ ] **Phase 2: Core Networking Foundation** - Implement the `BaseApiService` and global interceptors.
- [ ] **Phase 3: Auth & Profile Modularization** - Extract authentication and profile logic into dedicated services.
- [ ] **Phase 4: Domain Service Extraction** - Modularize book and library API logic.
- [ ] **Phase 5: Deep Link Decoupling** - Centralize deep link logic and clean up `main.dart`.
- [ ] **Phase 6: Final Audit & Validation** - Ensure project stability and verify all refactoring goals.

## Phase Details

### Phase 1: SDK & Infrastructure Modernization
**Goal**: Transition to a modern development environment.
**Depends on**: Nothing
**Requirements**: INFRA-01, INFRA-02, INFRA-03
**Success Criteria**:
  1. `pubspec.yaml` uses Dart `^3.0.0`.
  2. Project builds successfully in the new environment.
  3. `flutter analyze` passes with zero errors/warnings.
**Plans**: 2 plans

Plans:
- [ ] 01-01: SDK Upgrade and Dependency Refresh.
- [ ] 01-02: Quality Check and Build Validation.

### Phase 1.1: iOS Deep Link Priority Fix (INSERTED)
**Goal**: Resolve the issue where iOS deep links opened from Facebook redirect to the App Store instead of the app.
**Depends on**: Phase 1
**Requirements**: INIT-05, INIT-06 (New requirements to be added)
**Success Criteria**:
  1. Universal Links open directly into the app from the Notes/Mail app.
  2. Universal Links open directly from within the Facebook app browser.
  3. Correct AASA file provided for server-side upload.
**Plans**: 2 plans

Plans:
- [ ] 01.1-01: iOS Configuration and Entitlements Update.
- [ ] 01.1-02: AASA and Web Context Generation.

### Phase 2: Core Networking Foundation
**Goal**: Establish a standardized API request/response infrastructure.
**Depends on**: Phase 1
**Requirements**: NET-01, NET-02
**Success Criteria**:
  1. `BaseApiService` is implemented with configurable Dio defaults.
  2. Request/Response logging and error interceptors are active globally.
**Plans**: 2 plans

Plans:
- [ ] 02-01: BaseApiService Implementation.
- [ ] 02-02: Global Interceptors Setup.

### Phase 3: Auth & Profile Modularization
**Goal**: Separate user-related logic from the monolithic provider.
**Depends on**: Phase 2
**Requirements**: NET-03, NET-06
**Success Criteria**:
  1. `AuthService` handles all login/logout/social flows.
  2. `ProfileService` manages user information.
  3. `ApiProvider` is reduced in size by ~500 lines.
**Plans**: 1 plan

Plans:
- [ ] 03-01: Auth & Profile Service Extraction.

### Phase 4: Domain Service Extraction
**Goal**: Complete the modularization of the API layer.
**Depends on**: Phase 3
**Requirements**: NET-04, NET-05, NET-06
**Success Criteria**:
  1. `BookService` and `LibraryService` are functional.
  2. `ApiProvider` is fully deprecated or significantly reduced.
**Plans**: 2 plans

Plans:
- [ ] 04-01: Book Service Extraction.
- [ ] 04-02: Library Service Extraction.

### Phase 5: Deep Link Decoupling
**Goal**: Clean up the application entry point.
**Depends on**: Phase 4
**Requirements**: INIT-01, INIT-02, INIT-03, INIT-04
**Success Criteria**:
  1. `DeepLinkService` handles all URI parsing and logic.
  2. `main.dart` is clean and free of deep link implementation details.
  3. Deep link navigation (Library, Books, Reading) works as expected.
**Plans**: 2 plans

Plans:
- [ ] 05-01: DeepLinkService Implementation.
- [ ] 05-02: main.dart Cleanup and Integration.

### Phase 6: Final Audit & Validation
**Goal**: Ensure a stable, high-quality production-ready state.
**Depends on**: Phase 5
**Success Criteria**:
  1. All v1 requirements are marked as Complete.
  2. No regressions found in core user flows.
**Plans**: 1 plan

Plans:
- [ ] 06-01: Final Validation and Milestone Completion.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. SDK Upgrade | 0/2 | Not started | - |
| 1.1 iOS Link Fix | 0/2 | Not started | - |
| 2. Networking Base | 0/2 | Not started | - |
| 3. Auth Service | 0/1 | Not started | - |
| 4. Domain Services | 0/2 | Not started | - |
| 5. Deep Link Service | 0/2 | Not started | - |
| 6. Final Audit | 0/1 | Not started | - |
| 7. Auth Expire Fix | 1/1 | Completed | 2026-05-21 |

### Phase 7: Fix auth expiration logout behavior and login visibility on 420 error

**Goal:** Intercept 420/401 auth expiration failures globally and trigger a synchronized force logout reset.
**Requirements**: NET-07
**Depends on:** Phase 6
**Plans:** 1 plan

Plans:
- [x] 07-01: Interceptor Setup and Global Refactoring.

---
*Roadmap defined: 2026-04-04*
*Last updated: 2026-05-21 after completing Phase 7*
