# iOS Deep Link Testing Guide

## Quick Test Procedure

### Step 1: Clean Install
```bash
# In the project root
cd /Volumes/DebarshisSSD/Updated/ebook

# Clean iOS pods
cd ios
rm -rf Pods/ Podfile.lock
pod install
cd ..

# Clean Flutter
flutter clean
flutter pub get

# Build and run
flutter run --release
```

### Step 2: Delete Old App
**IMPORTANT**: Delete the existing app from your iOS device before installing the new version. iOS caches universal link configurations, so a fresh install is necessary.

### Step 3: Install New Version
Install the app either via:
- Xcode (Run from Xcode)
- TestFlight (upload new build)
- Direct installation

### Step 4: Test Links

#### Test 1: Messages App
1. Open Messages app
2. Send yourself this link: `https://tratri.in/link?id=123&format=e-book`
3. Tap the link
4. **Expected**: App should open directly
5. **If not**: Check Xcode console logs

#### Test 2: Notes App
1. Open Notes app
2. Create a note with: `https://tratri.in/bookDetails?id=123`
3. Tap the link
4. **Expected**: App should open directly

#### Test 3: Safari
1. Open Safari
2. Navigate to: `https://tratri.in/link?id=123&format=e-book`
3. **Expected**: App should open with a banner prompt

#### Test 4: Email
1. Send yourself an email with the link
2. Open Mail app
3. Tap the link
4. **Expected**: App should open directly

## Debugging

### View Logs in Xcode

1. Connect your iOS device
2. Open Xcode
3. Go to Window → Devices and Simulators
4. Select your device
5. Click "Open Console"
6. Filter by "AppDelegate" to see deep link logs

### Expected Log Output (Success)
```
🔗 AppDelegate: ========== UNIVERSAL LINK RECEIVED ==========
🔗 AppDelegate: Activity type: NSUserActivityTypeBrowsingWeb
🔗 AppDelegate: Webpage URL: https://tratri.in/link?id=123&format=e-book
🔗 AppDelegate: URL scheme: https
🔗 AppDelegate: URL host: tratri.in
🔗 AppDelegate: URL path: '/link'
🔗 AppDelegate: URL query: 'id=123&format=e-book'
🔗 AppDelegate: ✅ Domain matches tratri.in
🔗 AppDelegate: ✅ Accepting universal link for tratri.in domain
🔗 AppDelegate: ✅ Universal link handled - returning true
🔗 AppDelegate: ========== END UNIVERSAL LINK ==========
```

### Expected Log Output (Failure)
```
🔗 AppDelegate: ========== UNIVERSAL LINK RECEIVED ==========
🔗 AppDelegate: ❌ Domain doesn't match tratri.in: 'some-other-domain.com'
🔗 AppDelegate: ❌ Falling back to false
🔗 AppDelegate: ========== END UNIVERSAL LINK ==========
```

## Common Problems

### Problem: Link opens Safari instead of app

**Causes**:
1. Old app still installed (cached settings)
2. AASA file not loaded by iOS
3. Associated domains not properly configured

**Solutions**:
1. Delete app completely
2. Restart device
3. Reinstall app
4. Wait 5 minutes for iOS to re-validate AASA file

### Problem: Link redirects to App Store

**Causes**:
1. AppDelegate returning false (FIXED in this update)
2. AASA file misconfigured
3. Wrong Team ID or App ID

**Solutions**:
1. Verify AASA file: `curl https://tratri.in/.well-known/apple-app-site-association`
2. Check Team ID matches: `BAH4BK6A87`
3. Check App ID matches: `com.xamtech.tratri`

### Problem: "Open in app" banner doesn't show

**This is normal** - the banner only shows in Safari, not in other apps. Universal links should work without the banner in most apps.

## Test URLs

Use these URLs for testing different features:

### E-Book
```
https://tratri.in/link?id=123&format=e-book
```

### Magazine
```
https://tratri.in/link?id=456&format=magazine
```

### E-Note
```
https://tratri.in/link?id=789&format=e-note
```

### Library
```
https://tratri.in/link?id=111&format=library
```

### Reading (with page)
```
https://tratri.in/link?id=123&details=reading&page=5&format=e-book
```

### Direct Paths (matching AASA)
```
https://tratri.in/bookDetails?id=123
https://tratri.in/magazineDetails?id=456
https://tratri.in/categories
https://tratri.in/bookInfo?id=789
```

## Validation Tools

### 1. Branch.io AASA Validator
```
https://branch.io/resources/aasa-validator/
Domain: tratri.in
```

### 2. Apple's App Search API Validation Tool
```
https://search.developer.apple.com/appsearch-validation-tool/
```

### 3. Command Line Test
```bash
# Validate JSON format
curl -s https://tratri.in/.well-known/apple-app-site-association | python3 -m json.tool

# Check content type
curl -I https://tratri.in/.well-known/apple-app-site-association
# Should show: Content-Type: application/json
```

## Success Criteria

✅ Link opens app directly from Messages
✅ Link opens app directly from Notes
✅ Link opens app directly from Email
✅ Safari shows "Open in app" banner
✅ Xcode logs show "✅ Universal link handled"
✅ No App Store redirects when app is installed
✅ Deep link parameters are passed to Flutter code

## Rollback (if needed)

If you need to revert these changes:

```bash
cd /Volumes/DebarshisSSD/Updated/ebook
git checkout ios/Runner/AppDelegate.swift
git checkout ios/Runner/Info.plist
```

Then rebuild the app.
