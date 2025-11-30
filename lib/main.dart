import 'package:ebook/Storage/common_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Constants/theme_data.dart';
import 'Helper/navigator.dart';
import 'Helper/router.dart';
import 'Storage/app_storage.dart';
import 'Storage/data_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.instance.initializeStorage();
  // await Firebase.initializeApp(
  //   // name: "GPlusNewApp",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enhanced deep link handling with Facebook compatibility
  final appLinks = AppLinks();

  // Check initial link
  try {
    final initialLink = await appLinks.getInitialLink();
    print(" MAIN: =================================");
    print(" MAIN: Initial link: $initialLink");
    print(" MAIN: =================================");
    if (initialLink != null) {
      Storage.instance.setDeepLinkProcessed(true);
      print(" MAIN: Setting deep link processed flag BEFORE handling");
      _handleDeepLink(initialLink);
    } else {
      print(" MAIN: No initial link found");
    }
  } catch (e) {
    print(" MAIN: Error getting initial link: $e");
  }

  // Listen to all incoming links with enhanced handling and debouncing
  appLinks.uriLinkStream.listen((uri) {
    print(" MAIN: =================================");
    print(" MAIN: Received deep link: $uri");
    print(" MAIN: URI toString(): ${uri.toString()}");
    print(" MAIN: URI host: ${uri.host}");
    print(" MAIN: URI path: ${uri.path}");
    print(" MAIN: URI query: ${uri.query}");
    print(" MAIN: URI queryParameters: ${uri.queryParameters}");

    // Debounce mechanism to prevent duplicate processing
    final now = DateTime.now();
    final linkString = uri.toString();

    if (Storage.instance.lastProcessedLink == linkString &&
        Storage.instance.lastProcessedTime != null &&
        now.difference(Storage.instance.lastProcessedTime!) <
            Storage.debounceInterval) {
      print(" MAIN: Debouncing duplicate link: $linkString");
      print(" MAIN: =================================");
      return;
    }

    if (Storage.instance.isProcessingDeepLink) {
      print(" MAIN: Already processing a deep link, skipping");
      print(" MAIN: =================================");
      return;
    }

    Storage.instance.isProcessingDeepLink = true;

    Storage.instance.lastProcessedLink = linkString;
    Storage.instance.lastProcessedTime = now;

    print(" MAIN: Processing link (not debounced)");
    _handleDeepLink(uri);
    print(" MAIN: =================================");
  }, onError: (err) {
    print(" MAIN: =================================");
    print(" MAIN: Deep link error: $err");
    print(" MAIN: Error type: ${err.runtimeType}");
    print(" MAIN: =================================");
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

// Enhanced deep link handler
void _handleDeepLink(Uri uri) {
  print(" HANDLER: =================================");
  print(" HANDLER: Processing deep link: $uri");
  print(" HANDLER: Host: '${uri.host}'");
  print(" HANDLER: Path: '${uri.path}'");
  print(" HANDLER: Query: '${uri.query}'");
  print(
      " HANDLER: Current debounce state - last: ${Storage.instance.lastProcessedLink}, time: ${Storage.instance.lastProcessedTime}");

  try {
    // Handle tratri.in domain links with proper query parameter parsing
    if ((uri.host == 'tratri.in' || uri.host == 'www.tratri.in') &&
        (uri.path == '/link' || uri.path.startsWith('/link'))) {
      print(" HANDLER: Matching tratri.in/link pattern");
      _handleTratriLinkWithParams(uri);
    } else if (uri.path.startsWith('/app/')) {
      // Handle Facebook fallback format (/app/something)
      print(" HANDLER: Matching Facebook fallback format (/app/)");
      String actualPath = uri.path.replaceFirst('/app/', '/');
      Map<String, String> params = uri.queryParameters;
      _navigateToRoute(actualPath, params);
    } else if (uri.scheme == 'tratri') {
      // Handle custom scheme
      print(" HANDLER: Matching custom scheme (tratri://)");
      _navigateToRoute(uri.path, uri.queryParameters);
    } else {
      print(" HANDLER: No matching pattern found");
      print(
          " HANDLER: Host: '${uri.host}', Path: '${uri.path}', Scheme: '${uri.scheme}'");
      print(" HANDLER: Available patterns:");
      print(" HANDLER: - tratri.in/link or www.tratri.in/link");
      print(" HANDLER: - /app/ paths");
      print(" HANDLER: - tratri:// scheme");
      Navigation.instance.navigateAndReplace('/main');
      _clearDebounceState();
    }
  } catch (e) {
    print(" HANDLER: Exception occurred: $e");
    print(" HANDLER: Stack trace: ${StackTrace.current}");
    // Fallback to main page
    Navigation.instance.navigateAndReplace('/main');
    _clearDebounceState();
  } finally {
    Storage.instance.isProcessingDeepLink = false;
  }
  print(" HANDLER: =================================");
}

// Handle tratri.in/link with query parameters (the actual format used)
void _handleTratriLinkWithParams(Uri uri) {
  print(" LINK: Processing tratri.in/link with params: ${uri.queryParameters}");

  final params = uri.queryParameters;
  final format = params['format'];
  final id = params['id'];
  final details = params['details'];

  print(" LINK: Format: $format, ID: $id, Details: $details");

  // Handle different link types based on query parameters
  if (details == "reading") {
    print(" LINK: Storing reading link target");
    final image = params['image'] ?? '';
    Storage.instance.setTargetRoute('/bookDetails',
        arguments: "${int.tryParse(id ?? '0') ?? 0},$image");
    Storage.instance
        .setReadingBookPage(int.tryParse(params['page'] ?? '0') ?? 0);
    _setTabBasedOnFormat(format ?? 'e-book');
    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();
  } else if (details == "library" || format == "library") {
    print(" LINK: Storing library link target");
    if (id != null) {
      Storage.instance
          .setTargetRoute('/libraryDetails', arguments: int.tryParse(id) ?? 0);
      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
    }
  } else if (format == "magazine" && id != null) {
    print(" LINK: Storing magazine link target");
    Storage.instance.setTargetRoute('/magazineDetails', arguments: id);
    _setTabBasedOnFormat('magazine');
    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();
  } else if (format == "e-note" && id != null) {
    print(" LINK: Storing e-note link target");
    Storage.instance
        .setTargetRoute('/bookInfo', arguments: int.tryParse(id) ?? 0);
    _setTabBasedOnFormat('e-note');
    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();
  } else if (id != null) {
    print(" LINK: Storing default book info link target (e-book)");
    Storage.instance
        .setTargetRoute('/bookInfo', arguments: int.tryParse(id) ?? 0);
    _setTabBasedOnFormat('e-book');
    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();
  } else {
    print(" LINK: No valid parameters, no target stored");
    _clearDebounceState();
  }
}

void _handleTratriDomainLink(Uri uri) {
  print(" DOMAIN: Handling tratri domain link: $uri");

  // Enhanced validation for different link formats
  if (uri.queryParameters['details'] != null &&
      uri.queryParameters['id'] != null) {
    final details = uri.queryParameters['details']!;
    final id = uri.queryParameters['id']!;

    print(" DOMAIN: Details: $details, ID: $id");

    // First fetch book details if needed
    if (details != "library") {
      _fetchBookDetailsForLink(uri);
    }

    // Handle different link types
    if (details == "reading") {
      _handleReadingLink(uri);
    } else if (details == "library") {
      _handleLibraryLink(uri);
    } else {
      // Default book info
      Navigation.instance.navigate('/bookInfo', args: int.tryParse(id) ?? 0);
    }
  } else {
    // Fallback to query parameters approach
    Map<String, String> params = uri.queryParameters;
    _navigateToRoute('/', params);
  }
}

void _handleReadingLink(Uri uri) {
  print(" READING: Handling reading link");
  final format = uri.queryParameters['format'] ?? 'e-book';
  final id = uri.queryParameters['id'] ?? '0';
  final page = uri.queryParameters['page'] ?? '0';
  final image = uri.queryParameters['image'] ?? '';

  // Set current tab based on format
  Future.delayed(const Duration(milliseconds: 200), () {
    try {
      // Get the navigation context to access providers
      final context = Navigation.instance.navigatorKey.currentContext;
      if (context != null) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);

        // Set appropriate tab based on format
        if (format == 'e-book') {
          dataProvider.setCurrentTab(0);
          print(" READING: Set tab to e-books (0)");
        } else if (format == 'magazine') {
          dataProvider.setCurrentTab(1);
          print(" READING: Set tab to magazines (1)");
        } else if (format == 'e-note' || format == 'enotes') {
          dataProvider.setCurrentTab(2);
          print(" READING: Set tab to e-notes (2)");
        }
      }

      // Check if user is logged in
      if (Storage.instance.isLoggedIn) {
        // Set reading page and navigate using removeUntil + navigate pattern
        Storage.instance.setReadingBookPage(int.tryParse(page) ?? 0);
        Navigation.instance.navigateAndRemoveUntil('/main');
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigation.instance.navigate('/bookDetails',
              args: "${int.tryParse(id) ?? 0},$image");
        });
        print(
            " READING: Navigated to bookDetails with ID: $id, image: $image, page: $page");
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
        print(" READING: User not logged in, navigated to login");
      }
    } catch (e) {
      print(" READING: Error handling reading link: $e");
      Navigation.instance.navigateAndRemoveUntil('/main');
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigation.instance.navigate('/bookInfo', args: int.tryParse(id) ?? 0);
      });
    }
  });
}

void _handleLibraryLink(Uri uri) {
  print(" LIBRARY: Handling library link");

  // Handle both old format (details=library) and new format (format=library)
  final params = uri.queryParameters;
  final libraryIdString = params['id'];
  final format = params['format'];
  final details = params['details'];

  print(
      " LIBRARY: Params - ID: $libraryIdString, Format: $format, Details: $details");

  if (libraryIdString != null && libraryIdString.isNotEmpty) {
    final libraryId = int.tryParse(libraryIdString) ?? 0;
    if (libraryId > 0) {
      print(" LIBRARY: Navigating to library details with ID: $libraryId");
      Future.delayed(const Duration(milliseconds: 500), () {
        // Use removeUntil + navigate pattern
        Navigation.instance.navigateAndRemoveUntil('/main');
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigation.instance.navigate('/libraryDetails', args: libraryId);
        });
        print(" LIBRARY: Navigation completed");
        _clearDebounceState();
      });
    } else {
      print(" LIBRARY: Invalid library ID: $libraryIdString");
      Navigation.instance.navigateAndReplace('/main');
      _clearDebounceState();
    }
  } else {
    print(" LIBRARY: No library ID found in link");
    Navigation.instance.navigateAndReplace('/main');
    _clearDebounceState();
  }
}

Future<void> _fetchBookDetailsForLink(Uri uri) async {
  try {
    final id = uri.queryParameters['id'];
    if (id != null) {
      print(" FETCH: Fetching book details for ID: $id");
      // This will be handled by the individual pages that need the book details
      // We don't need to fetch it globally here as it might not be needed immediately
    }
  } catch (e) {
    print(" FETCH: Error fetching book details: $e");
  }
}

void _navigateToRoute(String path, Map<String, String> params) {
  print(" NAVIGATE: Starting navigation to path: $path with params: $params");

  // Clear any pending navigation state
  _clearPendingNavigation();

  // Instead of trying to navigate immediately, store the target route
  // The home page will check for this and navigate appropriately
  try {
    // Handle query parameter-based routing (legacy format)
    if (params['details'] != null && params['id'] != null) {
      final details = params['details']!;
      final id = params['id']!;

      print(" ROUTE: Legacy format - Details: $details, ID: $id");

      if (details == "reading") {
        print(" ROUTE: Storing reading link target");
        final format = params['format'] ?? 'e-book';
        final image = params['image'] ?? '';
        Storage.instance.setTargetRoute('/bookDetails',
            arguments: "${int.tryParse(id) ?? 0},$image");

        // Set reading page and tab
        Storage.instance
            .setReadingBookPage(int.tryParse(params['page'] ?? '0') ?? 0);
        _setTabBasedOnFormat(format);
      } else if (details == "library") {
        print(" ROUTE: Storing library link target");
        Storage.instance.setTargetRoute('/libraryDetails',
            arguments: int.tryParse(id) ?? 0);
      } else {
        print(" ROUTE: Storing book info target");
        Storage.instance
            .setTargetRoute('/bookInfo', arguments: int.tryParse(id) ?? 0);
      }

      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
      return;
    }

    // Handle path-based routing (new format)
    print(" ROUTE: Path-based routing for: $path");
    switch (path) {
      case '/bookDetails':
        if (params['id'] != null) {
          print(" ROUTE: Storing bookDetails target");
          Storage.instance
              .setTargetRoute('/bookDetails', arguments: params['id']!);
        }
        break;
      case '/magazineDetails':
        if (params['id'] != null) {
          print(" ROUTE: Storing magazineDetails target");
          Storage.instance
              .setTargetRoute('/magazineDetails', arguments: params['id']!);
          _setTabBasedOnFormat('magazine');
        }
        break;
      case '/categories':
        if (params['type'] != null) {
          print(" ROUTE: Storing categories target");
          Storage.instance
              .setTargetRoute('/categories', arguments: params['type']!);
        }
        break;
      case '/bookInfo':
        if (params['id'] != null) {
          print(" ROUTE: Storing bookInfo target");
          Storage.instance.setTargetRoute('/bookInfo',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      case '/libraryDetails':
        if (params['id'] != null) {
          print(" ROUTE: Storing libraryDetails target");
          Storage.instance.setTargetRoute('/libraryDetails',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      case '/reading':
        if (params['id'] != null) {
          print(" ROUTE: Storing reading target");
          Storage.instance.setTargetRoute('/reading',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      default:
        print(" ROUTE: Unknown path, no target stored: $path");
        break;
    }

    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();

    print(" NAVIGATE: Target route stored successfully");
  } catch (e) {
    print(" NAVIGATION: Error processing route: $e");
    print(" NAVIGATION: Stack trace: ${StackTrace.current}");
    _clearDebounceState();
  }
}

// Helper function to set tab based on format
void _setTabBasedOnFormat(String format) {
  Future.delayed(const Duration(milliseconds: 100), () {
    try {
      final context = Navigation.instance.navigatorKey.currentContext;
      if (context != null) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);

        if (format == 'e-book') {
          dataProvider.setCurrentTab(0);
          print(" TAB: Set to e-books (0)");
        } else if (format == 'magazine') {
          dataProvider.setCurrentTab(1);
          print(" TAB: Set to magazines (1)");
        } else if (format == 'e-note' || format == 'enotes') {
          dataProvider.setCurrentTab(2);
          print(" TAB: Set to e-notes (2)");
        }
      }
    } catch (e) {
      print(" TAB: Error setting tab: $e");
    }
  });
}

// Clear any pending navigation operations
void _clearPendingNavigation() {
  try {
    // This helps prevent navigation conflicts by ensuring we start with a clean state
    print(" CLEAR: Clearing pending navigation state");
    print(
        " CLEAR: Processing flag is: ${Storage.instance.isProcessingDeepLink}");
  } catch (e) {
    print(" CLEAR: Error clearing navigation state: $e");
  }
}

// Clear debounce state after successful navigation
void _clearDebounceState() {
  Future.delayed(const Duration(milliseconds: 500), () {
    Storage.instance.lastProcessedLink = null;
    Storage.instance.lastProcessedTime = null;
    Storage.instance.isProcessingDeepLink = false;
    Storage.instance.setDeepLinkProcessed(false);
    print(" DEBOUNCE: State cleared, processing flag reset");
  });
}

// Getter to check if deep link was processed (for splash screen)
bool get wasDeepLinkProcessed => Storage.instance.isDeepLinkProcessed;

// Global function to check deep link status
bool isDeepLinkProcessed() {
  return Storage.instance.isDeepLinkProcessed;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CommonProvider(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tratri',
          theme: AppTheme.getTheme(),
          navigatorKey: Navigation.instance.navigatorKey,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
