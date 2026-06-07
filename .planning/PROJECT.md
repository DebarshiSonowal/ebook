# ebook: Refactoring & Quality Milestone

## What This Is
A comprehensive refactoring effort for the `ebook` Flutter application to address technical debt in the networking and initialization layers. This project aims to transition from monolithic provider structures to modular services, improving maintainability and performance.

## Core Value
**Maintainability**: Decoupling complex logic from the application entry point and modularizing the service layer to enable faster, safer feature development.

## Requirements

### Validated
- ✓ Multi-platform Flutter core (Android/iOS) — existing
- ✓ Firebase Authentication integration — existing
- ✓ Razorpay & Google/Apple Pay integration — existing
- ✓ custom `tratri.in` deep link handling — existing
- ✓ Provider-based shared state management — existing

### Active
- [ ] **SDK Upgrade**: Transition to Dart `^3.0.0` to enable modern language features.
- [ ] **Networking Modularization**: Split the 2700+ line `ApiProvider` into domain-specific services (Auth, Books, Library).
- [ ] **Deep Link Decoupling**: Extract manual URI parsing and navigation logic from `main.dart` into a centralized `DeepLinkService`.
- [ ] **Base API Infrastructure**: Implement a standardized `BaseApiService` using Dio interceptors for global logging and error handling.

### Out of Scope
- **New Features**: No functional additions to the app until the refactoring is complete.
- **Backend Changes**: Refactoring is limited to the client-side Dart code.
- **State Management Migration**: Staying with `Provider` for this milestone; no migration to Riverpod/Bloc.

## Context
- **Current State**: The project suffers from "spaghetti" logic in `main.dart` and an oversized `ApiProvider`.
- **Tech Debt**: Manual deep link debouncing and parsing is prone to regression.
- **Environment**: Flutter project with a mix of legacy and modern dependencies.

## Constraints
- **Tech Stack**: Must remain Flutter/Dart compatible.
- **SDK Compatibility**: Upgrade must be compatible with existing third-party plugins (Firebase, Razorpay).
- **Architecture**: Must preserve the existing `Provider` ecosystem while improving its internal structure.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Upgrade to Dart 3.0 | Required for modern features and improved performance. | — Pending |
| Service Separation | `ApiProvider` has surpassed maintainable size. | — Pending |
| Deep Link Service | Decouples UI entry point from navigation business logic. | — Pending |

## Evolution
This document evolves at phase transitions and milestone boundaries.

**After each phase transition:**
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone:**
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-04 after gsd-new-project initialization*
