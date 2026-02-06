import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // shared_preferences
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  static const String _isOnBoarding = "isOnBoarding";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _notification = "notification";
  static const String _readingBookPage = "readingBookPage";
  static const String _cachePrefix = "api_cache_";
  static const String _cacheCountPrefix = "api_cache_count_";
  static const String _cacheTimePrefix = "api_cache_time_";

  // Deep link tracking
  bool _deepLinkProcessed = false;
  String? lastProcessedLink;
  DateTime? lastProcessedTime;
  bool isProcessingDeepLink = false;
  static const Duration debounceInterval = Duration(milliseconds: 1000);

  // Store target route for persistent navigation
  String? _targetRoute;
  Object? _targetArguments;
  
  // Track when initial data loading is complete
  bool _isDataLoaded = false;

  Future<void> initializeStorage() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUser(String token) async {
    await sharedpreferences.setString("token", token);
    await sharedpreferences.setBool("isLoggedIn", true);
    print('set user ${token}');
  }

  Future<void> setReadingBook(int id) async {
    await sharedpreferences.setInt("id", id);
  }

  Future<void> setReadingBookPage(int id) async {
    await sharedpreferences.setInt("page", id);
  }

  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  Future<void> logout() async {
    await sharedpreferences.clear();
    Fluttertoast.showToast(msg: "Successfully logged out");
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get readingBook => sharedpreferences.getInt("id") ?? 0;

  get readingBookPage => sharedpreferences.getInt("page") ?? 0;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token =>
      sharedpreferences.getString("token") ??
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdHJhdHJpLmluXC9hcGlcL3N1YnNjcmliZXJzXC9sb2dpbiIsImlhdCI6MTY2Mjk1OTk5NiwiZXhwIjoxNjYyOTYzNTk2LCJuYmYiOjE2NjI5NTk5OTYsImp0aSI6ImZ2MzYwZ09zNGdReVhsWWoiLCJzdWIiOjQsInBydiI6IjdhNTljY2RhNDc0MGVjOGU1ZDRmMGVhOGQyNjQ3YThiYWE3N2FjZGQifQ.2_F9m8Jw7iYj5jfDl24dU83foJxNU9tVzUUjQIvrTtE";

  void setDeepLinkProcessed(bool value) {
    _deepLinkProcessed = value;
    print("📍 DEEP LINK: Flag set to $value");
  }

  bool get isDeepLinkProcessed => _deepLinkProcessed;

  // Store target route for later navigation
  void setTargetRoute(String route, {Object? arguments}) {
    _targetRoute = route;
    _targetArguments = arguments;
    print(" TARGET: Stored route: $route with args: $arguments");
  }

  String? get targetRoute => _targetRoute;

  Object? get targetArguments => _targetArguments;

  void clearTargetRoute() {
    print(" TARGET: Clearing stored route: $_targetRoute");
    _targetRoute = null;
    _targetArguments = null;
  }

  // Data loading state management
  void setDataLoaded(bool value) {
    _isDataLoaded = value;
    print("📊 DATA: Initial data loading complete: $value");
  }

  bool get isDataLoaded => _isDataLoaded;

  // Cache management methods
  Future<void> setApiCache(String key, String jsonData) async {
    await sharedpreferences.setString('$_cachePrefix$key', jsonData);
    await sharedpreferences.setString('$_cacheTimePrefix$key',
        DateTime.now().millisecondsSinceEpoch.toString());

    // Reset fetch count when setting new cache
    await sharedpreferences.setInt('$_cacheCountPrefix$key', 0);

    print('✅ Cached API data for key: $key at ${DateTime.now()}');
  }

  String? getApiCache(String key) {
    final cacheTime = sharedpreferences.getString('$_cacheTimePrefix$key');
    final cacheCount = sharedpreferences.getInt('$_cacheCountPrefix$key') ?? 0;

    print('🔍 Checking cache for key: $key');

    if (cacheTime != null) {
      final cachedAt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(cacheTime));
      final now = DateTime.now();
      final timeDiff = now.difference(cachedAt).inMinutes;

      print('📊 Cache info - Age: ${timeDiff}m, Count: $cacheCount');

      // Check if cache is still valid (within 10 minutes and under 3 fetches)
      if (timeDiff < 10 && cacheCount < 3) {
        // Increment fetch count
        sharedpreferences.setInt('$_cacheCountPrefix$key', cacheCount + 1);

        final cachedData = sharedpreferences.getString('$_cachePrefix$key');
        print(
            '✅ Using cached data for key: $key, age: ${timeDiff}m, count: ${cacheCount + 1}');
        return cachedData;
      } else {
        print(
            '❌ Cache expired for key: $key, age: ${timeDiff}m, count: $cacheCount');
        // Clear expired cache
        clearApiCache(key);
      }
    } else {
      print('❌ No cache found for key: $key');
    }

    return null;
  }

  Future<void> clearApiCache(String key) async {
    await sharedpreferences.remove('$_cachePrefix$key');
    await sharedpreferences.remove('$_cacheTimePrefix$key');
    await sharedpreferences.remove('$_cacheCountPrefix$key');
    print('🗑️ Cleared cache for key: $key');
  }

  Future<void> clearAllApiCache() async {
    final keys = sharedpreferences.getKeys();
    int clearedCount = 0;
    for (String key in keys) {
      if (key.startsWith(_cachePrefix) ||
          key.startsWith(_cacheTimePrefix) ||
          key.startsWith(_cacheCountPrefix)) {
        await sharedpreferences.remove(key);
        clearedCount++;
      }
    }
    print('🗑️ Cleared all API cache ($clearedCount items)');
  }

  // Debug method to list all cached items
  void debugCacheStatus() {
    final keys = sharedpreferences.getKeys();
    final cacheKeys =
        keys.where((key) => key.startsWith(_cachePrefix)).toList();

    print('📊 Cache Status Report:');
    print('🔍 Total cache entries: ${cacheKeys.length}');

    for (String key in cacheKeys) {
      final cleanKey = key.replaceFirst(_cachePrefix, '');
      final timeKey = '$_cacheTimePrefix$cleanKey';
      final countKey = '$_cacheCountPrefix$cleanKey';

      final cacheTime = sharedpreferences.getString(timeKey);
      final cacheCount = sharedpreferences.getInt(countKey) ?? 0;

      if (cacheTime != null) {
        final cachedAt =
            DateTime.fromMillisecondsSinceEpoch(int.parse(cacheTime));
        final age = DateTime.now().difference(cachedAt).inMinutes;
        print('📝 $cleanKey: Age ${age}m, Fetches: $cacheCount');
      }
    }
  }
}
