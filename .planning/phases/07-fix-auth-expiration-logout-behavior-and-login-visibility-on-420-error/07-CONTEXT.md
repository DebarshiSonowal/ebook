# Phase 7: Fix auth expiration logout behavior and login visibility on 420 error - Context

**Gathered:** 2026-05-21
**Status:** Ready for planning

<domain>
## Phase Boundary
This phase focuses entirely on intercepting authentication-related API failures (such as standard status code 420 or 401 token expiration errors) and triggering a robust, global logout that completely cleans up user states and resets the UI immediately.

### Out of Scope:
- Modifying backend server logic or token refresh flows.
- Changes to user registration or authentication credentials logic.
</domain>

<decisions>
## Implementation Decisions

### D-01: Dio Global Interceptor for 420 / 401 Errors
- Intercept all Dio API errors.
- If status code is `420` (custom invalid/expired token code) or `401`, trigger global logout.
- Since `Dio` is currently instantiated inline in over 80 functions within `lib/Networking/api_provider.dart`, we will refactor all of those inline instantiations to use a single private builder method `_getDio(BaseOptions options)` or a wrapper inside `ApiProvider` to register a global interceptor.

### D-02: Global Force Logout Execution
- Force logout should execute three main actions synchronously:
  1. Clear Provider state: `Provider.of<DataProvider>(context, listen: false).clearAllData();` using the global root context.
  2. Clear persistent Storage: `Storage.instance.logout();` to clear tokens and `isLoggedIn` flag.
  3. Reset Navigation Stack: `Navigation.instance.navigateAndRemoveUntil('/main');` to wipe navigation history, force rebuild of core layouts (Appbar, Profile page), and return to `/main` landing page in a safe, unauthorized state.

### D-03: Global Root BuildContext Retrieval
- Retrieve active root `BuildContext` dynamically from anywhere using `Navigation.instance.navigatorKey.currentContext` (which is configured on the root MaterialApp) to allow state cleaning from inside the networking layer without passing the context through every method.
</decisions>

<canonical_refs>
## Canonical References
- `lib/Networking/api_provider.dart` — Custom API provider containing Dio client requests.
- `lib/Storage/app_storage.dart` — Local storage keys (`isLoggedIn`, `token`) and `logout()` method.
- `lib/Storage/data_provider.dart` — Primary state management and profile data (`clearAllData()`).
- `lib/Helper/navigator.dart` — Global navigation helper and root `navigatorKey`.
- `lib/UI/Components/new_searchbar.dart` — Login/Register button rendering checks.
- `lib/UI/Routes/Navigation Page/account_page.dart` — Profile screen actions.
</canonical_refs>
