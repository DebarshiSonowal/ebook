import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Debug launch options
    print("🔗 AppDelegate: didFinishLaunchingWithOptions called")
    if let options = launchOptions {
      print("🔗 AppDelegate: Launch options: \(options)")
      if let url = options[UIApplication.LaunchOptionsKey.url] as? URL {
        print("🔗 AppDelegate: Launch URL: \(url)")
        print("🔗 AppDelegate: Launch URL scheme: \(url.scheme ?? "none")")
        print("🔗 AppDelegate: Launch URL host: \(url.host ?? "none")")
        print("🔗 AppDelegate: Launch URL path: \(url.path)")
        print("🔗 AppDelegate: Launch URL query: \(url.query ?? "none")")
      }
      if let userActivityDict = options[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
        print("🔗 AppDelegate: User activity dict: \(userActivityDict)")
        for (key, value) in userActivityDict {
          print("🔗 AppDelegate: User activity key: \(key), value: \(value)")
        }
      }
    } else {
      print("🔗 AppDelegate: No launch options")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle Universal Links
  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    print("🔗 AppDelegate: ========== UNIVERSAL LINK RECEIVED ==========")
    print("🔗 AppDelegate: Activity type: \(userActivity.activityType)")
    print("🔗 AppDelegate: Activity title: \(userActivity.title ?? "none")")
    print("🔗 AppDelegate: Activity keywords: \(userActivity.keywords)")
    print("🔗 AppDelegate: Activity userInfo: \(userActivity.userInfo ?? [:])")
    
    if let webpageURL = userActivity.webpageURL {
      print("🔗 AppDelegate: Webpage URL: \(webpageURL.absoluteString)")
      print("🔗 AppDelegate: URL scheme: \(webpageURL.scheme ?? "none")")
      print("🔗 AppDelegate: URL host: \(webpageURL.host ?? "none")")
      print("🔗 AppDelegate: URL path: '\(webpageURL.path)'")
      print("🔗 AppDelegate: URL query: '\(webpageURL.query ?? "none")'")
      print("🔗 AppDelegate: URL fragment: '\(webpageURL.fragment ?? "none")'")
      
      // More detailed host checking
      if let host = webpageURL.host {
        print("🔗 AppDelegate: Host comparison - received: '\(host)', expected: 'tratri.in'")
        print("🔗 AppDelegate: Host match: \(host == "tratri.in")")
        print("🔗 AppDelegate: Host contains: \(host.contains("tratri.in"))")
      }
      
      // Check if it's a supported domain
      if webpageURL.host == "tratri.in" || webpageURL.host == "www.tratri.in" {
        print("🔗 AppDelegate: ✅ Domain matches tratri.in")
        
        // Log the path to understand what's being received
        let path = webpageURL.path
        print("🔗 AppDelegate: URL path analysis - received: '\(path)'")
        
        // Validate the path matches expected patterns
        let supportedPaths = ["/link", "/book/", "/reading/"]
        print("🔗 AppDelegate: Supported paths: \(supportedPaths)")
        
        var pathMatches = false
        var matchedPattern = ""
        
        for pathPattern in supportedPaths {
          if pathPattern.endsWith("/") {
            // Pattern ends with slash - check if path starts with it
            if path.hasPrefix(pathPattern) {
              pathMatches = true
              matchedPattern = pathPattern
              break
            }
          } else {
            // Exact match
            if path == pathPattern {
              pathMatches = true
              matchedPattern = pathPattern
              break
            }
          }
        }
        
        print("🔗 AppDelegate: Path matches: \(pathMatches), pattern: '\(matchedPattern)'")
        
        if pathMatches {
          print("🔗 AppDelegate: ✅ Path matches supported patterns")
          
          // Additional validation - check if URL looks like a valid deep link
          if webpageURL.query?.contains("id=") == true {
            print("🔗 AppDelegate: ✅ URL contains id parameter")
          } else {
            print("🔗 AppDelegate: ⚠️ URL does not contain id parameter")
          }
          
          // Let the plugin handle it
          print("🔗 AppDelegate: Calling super.application for universal link handling")
          let result = super.application(application, continue: userActivity, restorationHandler: restorationHandler)
          print("🔗 AppDelegate: Super result: \(result)")
          
          // Force return true to ensure the link is handled
          if result {
            print("🔗 AppDelegate: ✅ Universal link handled successfully")
          } else {
            print("🔗 AppDelegate: ⚠️ Super returned false, but forcing true")
          }
          return true
        } else {
          print("🔗 AppDelegate: ❌ Path doesn't match supported patterns: '\(path)'")
        }
      } else {
        print("🔗 AppDelegate: ❌ Domain doesn't match tratri.in: '\(webpageURL.host ?? "unknown")'")
      }
    } else {
      print("🔗 AppDelegate: ❌ No webpage URL found in user activity")
    }
    
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      print("🔗 AppDelegate: Processing as web browsing activity (fallback)")
      let result = super.application(application, continue: userActivity, restorationHandler: restorationHandler)
      print("🔗 AppDelegate: Super result for web browsing: \(result)")
      return result
    }
    
    print("🔗 AppDelegate: ❌ Falling back to false")
    print("🔗 AppDelegate: ========== END UNIVERSAL LINK ==========")
    return false
  }
  
  // Handle custom URL schemes
  override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    print("🔗 AppDelegate: ========== CUSTOM URL SCHEME ==========")
    print("🔗 AppDelegate: Custom URL scheme: \(url)")
    print("🔗 AppDelegate: URL scheme: \(url.scheme ?? "none")")
    print("🔗 AppDelegate: URL host: \(url.host ?? "none")")
    print("🔗 AppDelegate: URL path: \(url.path)")
    print("🔗 AppDelegate: URL query: \(url.query ?? "none")")
    print("🔗 AppDelegate: Options: \(options)")
    
    let result = super.application(application, open: url, options: options)
    print("🔗 AppDelegate: Custom URL result: \(result)")
    print("🔗 AppDelegate: ========== END CUSTOM URL ==========")
    return result
  }
  
  // Handle universal links when app is already running
  override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    print("🔗 AppDelegate: Will continue user activity with type: \(userActivityType)")
    if userActivityType == NSUserActivityTypeBrowsingWeb {
      print("🔗 AppDelegate: ✅ Will continue browsing web activity")
    }
    return super.application(application, willContinueUserActivityWithType: userActivityType)
  }
  
  // Handle errors in universal links
  override func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
    print("🔗 AppDelegate: ❌ Failed to continue user activity: \(userActivityType)")
    print("🔗 AppDelegate: ❌ Error: \(error.localizedDescription)")
    print("🔗 AppDelegate: ❌ Error details: \(error)")
    super.application(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
  }
}