# Facebook Deep Link Solution for Tratri App

This solution addresses the issue where Facebook's in-app browser doesn't properly handle app links
and redirects to the Play Store instead of opening the app directly.

## Problem

When app links are shared on Facebook and opened from there:

1. Facebook's in-app browser opens the link
2. Instead of opening the app, it redirects to Play Store
3. Users need to click "Open in external browser" to get the app to open
4. This creates friction and poor user experience

## Solution Overview

The solution creates a fallback web page that:

1. Detects Facebook's in-app browser
2. Provides clear instructions to users
3. Attempts multiple methods to open the app
4. Shows the prompt similar to Firebase Dynamic Links
5. Gracefully falls back to app store if needed

## Files Changed

### 1. Android Manifest (`android/app/src/main/AndroidManifest.xml`)

- Added comprehensive deep link configurations
- Added Facebook-specific fallback paths (`/app/*`)
- Enhanced intent filters for better compatibility

### 2. Main App (`lib/main.dart`)

- Enhanced deep link handling
- Added proper routing for new paths
- Better error handling and fallbacks

### 3. iOS Configuration (`ios/Runner/Info.plist`)

- Added associated domains for universal links
- Enhanced URL scheme handling

### 4. Web Fallback Page (`web/facebook_fallback.html`)

- Beautiful, responsive fallback page
- Facebook in-app browser detection
- Multiple app opening strategies
- Clear user instructions
- Auto-retry mechanisms

### 5. Digital Asset Links (`web/.well-known/assetlinks.json`)

- Android app verification file
- Required for App Links to work

### 6. Apple App Site Association (`web/.well-known/apple-app-site-association`)

- iOS universal links verification file
- Required for iOS app links to work

## Deployment Steps

### Step 1: Get Your App Signing Certificate Fingerprints

**For Android:**

```bash
# For debug builds
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release builds (replace with your keystore path)
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

Copy the SHA256 fingerprint and replace `ADD_YOUR_SHA256_FINGERPRINT_HERE` in
`web/.well-known/assetlinks.json`.

**For iOS:**
Get your Team ID from Apple Developer Console and replace `TEAM_ID` in
`web/.well-known/apple-app-site-association`.

### Step 2: Host the Web Files

Upload these files to your web server at `tratri.in`:

1. `web/.well-known/assetlinks.json` → `https://tratri.in/.well-known/assetlinks.json`
2. `web/.well-known/apple-app-site-association` →
   `https://tratri.in/.well-known/apple-app-site-association`
3. `web/facebook_fallback.html` → `https://tratri.in/app/index.html`

**Important:** The `.well-known` files must be accessible without authentication and return correct
MIME types:

- `assetlinks.json` → `application/json`
- `apple-app-site-association` → `application/json`

### Step 3: Set Up URL Redirects

Configure your web server to redirect Facebook fallback URLs:

**Apache (.htaccess):**

```apache
RewriteEngine On
RewriteRule ^app/(.*)$ /facebook_fallback.html?route=$1 [QSA,L]
```

**Nginx:**

```nginx
location ~ ^/app/(.*)$ {
    try_files $uri /facebook_fallback.html?route=$1;
}
```

### Step 4: Test Your Links

Test these URLs:

- `https://tratri.in/link/bookDetails?id=123` (should open app directly)
- `https://tratri.in/app/bookDetails?id=123` (should show fallback page)

### Step 5: Verify App Links

**Android:**

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://tratri.in/link/bookDetails?id=123" com.tsinfosec.ebook.ebook
```

**Test Digital Asset Links:**
Visit:
`https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://tratri.in&relation=delegate_permission/common.handle_all_urls`

## How It Works

### Normal Browsers

1. User clicks link: `https://tratri.in/link/bookDetails?id=123`
2. Android App Links verification succeeds
3. App opens directly with deep link

### Facebook In-App Browser

1. User clicks link: `https://tratri.in/link/bookDetails?id=123`
2. Facebook's WebView doesn't properly handle App Links
3. User gets redirected to `https://tratri.in/app/bookDetails?id=123`
4. Fallback page loads and detects Facebook browser
5. Page shows clear instructions and "Open in Browser" message
6. When user taps "Open in External Browser", the universal link works
7. App opens properly with the deep link

## Sharing Strategy

When sharing links for Facebook, use the `/app/` format:

- **For Facebook sharing:** `https://tratri.in/app/bookDetails?id=123`
- **For other platforms:** `https://tratri.in/link/bookDetails?id=123`

This ensures Facebook users get the helpful fallback page while other users get direct app opening.

## Testing Checklist

- [ ] App opens directly from Chrome/Safari
- [ ] Facebook in-app browser shows fallback page
- [ ] Fallback page detects Facebook correctly
- [ ] "Open in Browser" instructions are clear
- [ ] App opens after following instructions
- [ ] Play Store link works if app not installed
- [ ] iOS universal links work properly
- [ ] Deep link parameters are passed correctly

## Troubleshooting

### App Links Not Working

1. Verify assetlinks.json is accessible and valid
2. Check SHA256 fingerprint matches your app signing certificate
3. Ensure domain verification is successful
4. Test with adb commands

### iOS Universal Links Not Working

1. Verify apple-app-site-association is accessible
2. Check Team ID is correct
3. Ensure associated domains are added to app entitlements
4. Test with iOS Simulator

### Facebook Detection Not Working

1. Check browser user agent in console
2. Verify Facebook user agent strings are up to date
3. Test with actual Facebook app, not mobile browser

## Advanced Customization

You can customize the fallback page by modifying `web/facebook_fallback.html`:

- Update branding and colors
- Add your own logo
- Modify messaging
- Add analytics tracking
- Customize app opening logic

Remember to test all changes thoroughly across different browsers and platforms!