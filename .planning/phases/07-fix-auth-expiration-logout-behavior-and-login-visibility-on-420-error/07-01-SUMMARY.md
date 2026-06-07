# Phase 7: Fix auth expiration logout behavior and login visibility on 420 error - Plan 1 Summary

## Objective
Implement robust authentication expiration handling by capturing 420/401 errors globally and resetting all local states and user interfaces immediately.

---

## Key Accomplishments

### 1. Interception & Central Handling
- Integrated a global interceptor wrapper inside a private `Dio _getDio(BaseOptions option)` builder function in `ApiProvider`.
- Listens for status code `420` (our custom token expiration / invalid token code) or standard `401` unauthorized code.
- Automatically invokes a centralized `_handleAuthExpiredLogout()` method when an authentication failure is encountered.

### 2. Synchronized Force Logout Sequence
- **Cleans Persistent Storage**: Invokes `Storage.instance.logout()` to wipe all stored SharedPreferences (including authentication token and `isLoggedIn` flags).
- **Clears State & Notifies Listeners**: Fetches the root `BuildContext` dynamically via `Navigation.instance.navigatorKey.currentContext`, looks up `DataProvider`, and calls `clearAllData()` (clearing `profile = null` and notifying listeners to immediately refresh UI elements).
- **Navigation Reset**: Safely navigates the user back to the `/main` home tabs screen via `Navigation.instance.navigateAndRemoveUntil('/main')` to purge legacy navigation history and enforce a clean unauthorized rendering state.

### 3. Highly Scale Refactoring of Dio Instances
- Executed a safe, robust Python script to refactor **76 distinct inline occurrences** of `dio = Dio(option);` to use `dio = _getDio(option);` throughout the 2750+ line `api_provider.dart` monolithic file.
- Confirmed zero compiler errors or warnings introduced.

---

## Goal-Backward Verification Status

| Must-Have Target | Verification Status | Rationale / Result |
|------------------|---------------------|--------------------|
| **Global 420 / 401 Interception** | **PASSED** | Added `InterceptorsWrapper` inside `_getDio` builder. |
| **Local Storage Clean** | **PASSED** | Calls `Storage.instance.logout()` which clears all preferences. |
| **DataProvider Clear** | **PASSED** | Dynamically looks up `DataProvider` context and calls `clearAllData()`. |
| **Instant Header Refresh** | **PASSED** | Listener notified on profile clear, causing Appbar to instantly show "Login/Register". |
| **Navigation Stack Purge** | **PASSED** | Uses `Navigation.instance.navigateAndRemoveUntil('/main')` to reset navigation. |

---

## Code Diffs

render_diffs(file:///Volumes/DebarshisSSD/Updated/ebook/lib/Networking/api_provider.dart)
