# iOS Deep Link Fix: Web Integration Guide

To ensure that Universal Links and Facebook App Links work correctly for `tratri.in`, you need to perform two server-side updates.

## 1. Apple App Site Association (AASA)

You must host the AASA file on your server to prove ownership of the domain to Apple.

- **URL**: `https://tratri.in/.well-known/apple-app-site-association`
- **Content-Type**: `application/json` (Must NOT have a `.json` extension in the filename on the server).
- **HTTPS**: Must be served over a valid HTTPS connection.

### AASA Content
Use the following JSON (generated based on your **Team ID: BAH4BK6A87** and **Bundle ID: com.xamtech.tratri**):

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "BAH4BK6A87.com.xamtech.tratri",
        "paths": [
          "*",
          "/link/*"
        ]
      }
    ]
  },
  "webcredentials": {
    "apps": [
      "BAH4BK6A87.com.xamtech.tratri"
    ]
  }
}
```

## 2. Meta/Open Graph Tags (Facebook Compatibility)

Facebook uses its own "App Links" protocol. To ensure the Facebook app redirects to your app instead of the App Store, add the following meta tags to the `<head>` of your website:

```html
<!-- App Links Configuration -->
<meta property="al:ios:url" content="tratri://link" />
<meta property="al:ios:app_store_id" content="YOUR_APP_STORE_ID" />
<meta property="al:ios:app_name" content="Tratri" />
<meta property="al:android:url" content="tratri://link" />
<meta property="al:android:package" content="com.xamtech.tratri" />
<meta property="al:android:app_name" content="Tratri" />
<meta property="al:web:should_fallback" content="false" />
```

> [!IMPORTANT]
> **YOUR_APP_STORE_ID**: Replace this with your actual App Store ID (the numeric ID in the App Store URL).

---

## 3. Testing the Fix

After deploying the AASA file:
1. **Reinstall the App**: iOS caches the AASA file on install.
2. **Notes/Mail Test**: Paste `https://tratri.in/link` in the iOS Notes app and long-press it. It should show "Open in Tratri".
3. **Facebook Debugger**: Use the [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/sharing/) to scrape your URL and verify that App Links are recognized.
