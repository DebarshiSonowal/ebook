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
import 'package:google_sign_in/google_sign_in.dart';

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
  // google_sign_in v7 requires initialize() before any other calls
  await GoogleSignIn.instance.initialize();

  // Enhanced deep link handling with Facebook compatibility
  final appLinks = AppLinks();

  // Check initial link
  try {
    final initialLink = await appLinks.getInitialLink();
    print(" [DeepLinkDebug MAIN]: =================================");
    print(" [DeepLinkDebug MAIN]: Initial link: $initialLink");
    print(" [DeepLinkDebug MAIN]: =================================");
    if (initialLink != null) {
      Storage.instance.setDeepLinkProcessed(true);
      print(" [DeepLinkDebug MAIN]: Setting deep link processed flag BEFORE handling");
      _handleDeepLink(initialLink);
    } else {
      print(" [DeepLinkDebug MAIN]: No initial link found");
    }
  } catch (e) {
    print(" [DeepLinkDebug MAIN]: Error getting initial link: $e");
  }

  // Listen to all incoming links with enhanced handling and debouncing
  appLinks.uriLinkStream.listen((uri) {
    print(" [DeepLinkDebug MAIN]: =================================");
    print(" [DeepLinkDebug MAIN]: Received deep link: $uri");
    print(" [DeepLinkDebug MAIN]: URI toString(): ${uri.toString()}");
    print(" [DeepLinkDebug MAIN]: URI host: ${uri.host}");
    print(" [DeepLinkDebug MAIN]: URI path: ${uri.path}");
    print(" [DeepLinkDebug MAIN]: URI query: ${uri.query}");
    print(" [DeepLinkDebug MAIN]: URI queryParameters: ${uri.queryParameters}");

    // Debounce mechanism to prevent duplicate processing
    final now = DateTime.now();
    final linkString = uri.toString();

    if (Storage.instance.lastProcessedLink == linkString &&
        Storage.instance.lastProcessedTime != null &&
        now.difference(Storage.instance.lastProcessedTime!) <
            Storage.debounceInterval) {
      print(" [DeepLinkDebug MAIN]: Debouncing duplicate link: $linkString");
      print(" [DeepLinkDebug MAIN]: =================================");
      return;
    }

    if (Storage.instance.isProcessingDeepLink) {
      print(" [DeepLinkDebug MAIN]: Already processing a deep link, skipping");
      print(" [DeepLinkDebug MAIN]: =================================");
      return;
    }

    Storage.instance.isProcessingDeepLink = true;

    Storage.instance.lastProcessedLink = linkString;
    Storage.instance.lastProcessedTime = now;

    print(" [DeepLinkDebug MAIN]: Processing link (not debounced)");
    _handleDeepLink(uri);
    print(" [DeepLinkDebug MAIN]: =================================");
  }, onError: (err) {
    print(" [DeepLinkDebug MAIN]: =================================");
    print(" [DeepLinkDebug MAIN]: Deep link error: $err");
    print(" [DeepLinkDebug MAIN]: Error type: ${err.runtimeType}");
    print(" [DeepLinkDebug MAIN]: =================================");
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

// Enhanced deep link handler
void _handleDeepLink(Uri uri) {
  print(" [DeepLinkDebug HANDLER]: =================================");
  print(" [DeepLinkDebug HANDLER]: Processing deep link: $uri");
  print(" [DeepLinkDebug HANDLER]: Host: '${uri.host}'");
  print(" [DeepLinkDebug HANDLER]: Path: '${uri.path}'");
  print(" [DeepLinkDebug HANDLER]: Query: '${uri.query}'");
  print(
      " HANDLER: Current debounce state - last: ${Storage.instance.lastProcessedLink}, time: ${Storage.instance.lastProcessedTime}");

  try {
    // Handle tratri.in domain links with proper query parameter parsing
    if ((uri.host == 'tratri.in' || uri.host == 'www.tratri.in') &&
        (uri.path == '/link' || uri.path.startsWith('/link'))) {
      print(" [DeepLinkDebug HANDLER]: Matching tratri.in/link pattern");
      _handleTratriLinkWithParams(uri);
    } else if (uri.path.startsWith('/app/')) {
      // Handle Facebook fallback format (/app/something)
      print(" [DeepLinkDebug HANDLER]: Matching Facebook fallback format (/app/)");
      String actualPath = uri.path.replaceFirst('/app/', '/');
      Map<String, String> params = uri.queryParameters;
      _navigateToRoute(actualPath, params);
    } else if (uri.scheme == 'tratri') {
      // Handle custom scheme
      print(" [DeepLinkDebug HANDLER]: Matching custom scheme (tratri://)");
      _navigateToRoute(uri.path, uri.queryParameters);
    } else {
      print(" [DeepLinkDebug HANDLER]: No matching pattern found");
      print(
          " HANDLER: Host: '${uri.host}', Path: '${uri.path}', Scheme: '${uri.scheme}'");
      print(" [DeepLinkDebug HANDLER]: Available patterns:");
      print(" [DeepLinkDebug HANDLER]: - tratri.in/link or www.tratri.in/link");
      print(" [DeepLinkDebug HANDLER]: - /app/ paths");
      print(" [DeepLinkDebug HANDLER]: - tratri:// scheme");
      Navigation.instance.navigateAndReplace('/main');
      _clearDebounceState();
    }
  } catch (e) {
    print(" [DeepLinkDebug HANDLER]: Exception occurred: $e");
    print(" [DeepLinkDebug HANDLER]: Stack trace: ${StackTrace.current}");
    // Fallback to main page
    Navigation.instance.navigateAndReplace('/main');
    _clearDebounceState();
  } finally {
    Storage.instance.isProcessingDeepLink = false;
  }
  print(" [DeepLinkDebug HANDLER]: =================================");
}

// Handle tratri.in/link with query parameters (the actual format used)
void _handleTratriLinkWithParams(Uri uri) {
  print(" [DeepLinkDebug LINK]: Processing tratri.in/link with params: ${uri.queryParameters}");

  final params = uri.queryParameters;
  final format = params['format'];
  final id = params['id'];
  final details = params['details'];

  print(" [DeepLinkDebug LINK]: Format: $format, ID: $id, Details: $details");

  // Handle different link types based on query parameters
  if (format == "library_home") {
    print(" [DeepLinkDebug LINK]: Storing library home link target");
    Storage.instance.setTargetRoute('/libraryHome');
    Storage.instance.setDeepLinkProcessed(true);
    _setTabBasedOnFormat(format ?? '');
    _clearDebounceState();
  } else if (id == null || id.isEmpty) {
    // Other links REQUIRE an ID
    print(" [DeepLinkDebug LINK]: ❌ Missing or empty ID parameter for format: $format, cannot process deep link");
    _clearDebounceState();
    return;
  } else {
    final parsedId = int.tryParse(id);
    if (parsedId == null || parsedId <= 0) {
      print(" [DeepLinkDebug LINK]: ❌ Invalid ID parameter: $id");
      _clearDebounceState();
      return;
    }

    if (details == "reading") {
      print(" [DeepLinkDebug LINK]: Storing reading link target");
      final image = params['image'] ?? '';
      Storage.instance.setTargetRoute('/bookDetails',
          arguments: "${parsedId},$image");
      Storage.instance
          .setReadingBookPage(int.tryParse(params['page'] ?? '0') ?? 0);
      _setTabBasedOnFormat(format ?? 'e-book');
      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
    } else if (details == "library" || format == "library") {
      print(" [DeepLinkDebug LINK]: Storing library link target");
      Storage.instance
          .setTargetRoute('/libraryDetails', arguments: parsedId);
      Storage.instance.setDeepLinkProcessed(true);
      _setTabBasedOnFormat(format ?? '');
      _clearDebounceState();
    } else if (format == "magazine") {
      print(" [DeepLinkDebug LINK]: Storing magazine link target");
      Storage.instance.setTargetRoute('/magazineDetails', arguments: id);
      _setTabBasedOnFormat('magazine');
      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
    } else if (format == "e-note") {
      print(" [DeepLinkDebug LINK]: Storing e-note link target");
      Storage.instance
          .setTargetRoute('/bookInfo', arguments: parsedId);
      _setTabBasedOnFormat('e-note');
      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
    } else {
      print(" [DeepLinkDebug LINK]: Storing default book info link target (e-book)");
      Storage.instance
          .setTargetRoute('/bookInfo', arguments: parsedId);
      _setTabBasedOnFormat('e-book');
      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
    }
  }
}

void _handleTratriDomainLink(Uri uri) {
  print(" [DeepLinkDebug DOMAIN]: Handling tratri domain link: $uri");

  // Enhanced validation for different link formats
  if (uri.queryParameters['details'] != null &&
      uri.queryParameters['id'] != null) {
    final details = uri.queryParameters['details']!;
    final id = uri.queryParameters['id']!;

    print(" [DeepLinkDebug DOMAIN]: Details: $details, ID: $id");

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
  print(" [DeepLinkDebug READING]: Handling reading link");
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
          print(" [DeepLinkDebug READING]: Set tab to e-books (0)");
        } else if (format == 'magazine') {
          dataProvider.setCurrentTab(1);
          print(" [DeepLinkDebug READING]: Set tab to magazines (1)");
        } else if (format == 'e-note' || format == 'enotes') {
          dataProvider.setCurrentTab(2);
          print(" [DeepLinkDebug READING]: Set tab to e-notes (2)");
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
        print(" [DeepLinkDebug READING]: User not logged in, navigated to login");
      }
    } catch (e) {
      print(" [DeepLinkDebug READING]: Error handling reading link: $e");
      Navigation.instance.navigateAndRemoveUntil('/main');
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigation.instance.navigate('/bookInfo', args: int.tryParse(id) ?? 0);
      });
    }
  });
}

void _handleLibraryLink(Uri uri) {
  print(" [DeepLinkDebug LIBRARY]: Handling library link");

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
      print(" [DeepLinkDebug LIBRARY]: Navigating to library details with ID: $libraryId");
      Future.delayed(const Duration(milliseconds: 500), () {
        // Use removeUntil + navigate pattern
        Navigation.instance.navigateAndRemoveUntil('/main');
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigation.instance.navigate('/libraryDetails', args: libraryId);
        });
        print(" [DeepLinkDebug LIBRARY]: Navigation completed");
        _clearDebounceState();
      });
    } else {
      print(" [DeepLinkDebug LIBRARY]: Invalid library ID: $libraryIdString");
      Navigation.instance.navigateAndReplace('/main');
      _clearDebounceState();
    }
  } else {
    print(" [DeepLinkDebug LIBRARY]: No library ID found in link");
    Navigation.instance.navigateAndReplace('/main');
    _clearDebounceState();
  }
}

Future<void> _fetchBookDetailsForLink(Uri uri) async {
  try {
    final id = uri.queryParameters['id'];
    if (id != null) {
      print(" [DeepLinkDebug FETCH]: Fetching book details for ID: $id");
      // This will be handled by the individual pages that need the book details
      // We don't need to fetch it globally here as it might not be needed immediately
    }
  } catch (e) {
    print(" [DeepLinkDebug FETCH]: Error fetching book details: $e");
  }
}

void _navigateToRoute(String path, Map<String, String> params) {
  print(" [DeepLinkDebug NAVIGATE]: Starting navigation to path: $path with params: $params");

  // Clear any pending navigation state
  _clearPendingNavigation();

  // Instead of trying to navigate immediately, store the target route
  // The home page will check for this and navigate appropriately
  try {
    // Handle query parameter-based routing (legacy format)
    if (params['details'] != null && params['id'] != null) {
      final details = params['details']!;
      final id = params['id']!;

      print(" [DeepLinkDebug ROUTE]: Legacy format - Details: $details, ID: $id");

      if (details == "reading") {
        print(" [DeepLinkDebug ROUTE]: Storing reading link target");
        final format = params['format'] ?? 'e-book';
        final image = params['image'] ?? '';
        Storage.instance.setTargetRoute('/bookDetails',
            arguments: "${int.tryParse(id) ?? 0},$image");

        // Set reading page and tab
        Storage.instance
            .setReadingBookPage(int.tryParse(params['page'] ?? '0') ?? 0);
        _setTabBasedOnFormat(format);
      } else if (details == "library") {
        print(" [DeepLinkDebug ROUTE]: Storing library link target");
        Storage.instance.setTargetRoute('/libraryDetails',
            arguments: int.tryParse(id) ?? 0);
      } else {
        print(" [DeepLinkDebug ROUTE]: Storing book info target");
        Storage.instance
            .setTargetRoute('/bookInfo', arguments: int.tryParse(id) ?? 0);
      }

      Storage.instance.setDeepLinkProcessed(true);
      _clearDebounceState();
      return;
    }

    // Handle path-based routing (new format)
    print(" [DeepLinkDebug ROUTE]: Path-based routing for: $path");
    switch (path) {
      case '/bookDetails':
        if (params['id'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing bookDetails target");
          Storage.instance
              .setTargetRoute('/bookDetails', arguments: params['id']!);
        }
        break;
      case '/magazineDetails':
        if (params['id'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing magazineDetails target");
          Storage.instance
              .setTargetRoute('/magazineDetails', arguments: params['id']!);
          _setTabBasedOnFormat('magazine');
        }
        break;
      case '/categories':
        if (params['type'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing categories target");
          Storage.instance
              .setTargetRoute('/categories', arguments: params['type']!);
        }
        break;
      case '/bookInfo':
        if (params['id'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing bookInfo target");
          Storage.instance.setTargetRoute('/bookInfo',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      case '/libraryDetails':
        if (params['id'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing libraryDetails target");
          Storage.instance.setTargetRoute('/libraryDetails',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      case '/reading':
        if (params['id'] != null) {
          print(" [DeepLinkDebug ROUTE]: Storing reading target");
          Storage.instance.setTargetRoute('/reading',
              arguments: int.tryParse(params['id']!) ?? 0);
        }
        break;
      default:
        print(" [DeepLinkDebug ROUTE]: Unknown path, no target stored: $path");
        break;
    }

    Storage.instance.setDeepLinkProcessed(true);
    _clearDebounceState();

    print(" [DeepLinkDebug NAVIGATE]: Target route stored successfully");
  } catch (e) {
    print(" [DeepLinkDebug NAVIGATION]: Error processing route: $e");
    print(" [DeepLinkDebug NAVIGATION]: Stack trace: ${StackTrace.current}");
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
          print(" [DeepLinkDebug TAB]: Set to e-books (0)");
        } else if (format == 'magazine') {
          dataProvider.setCurrentTab(1);
          print(" [DeepLinkDebug TAB]: Set to magazines (1)");
        } else if (format == 'e-note' || format == 'enotes') {
          dataProvider.setCurrentTab(2);
          print(" [DeepLinkDebug TAB]: Set to e-notes (2)");
        } else {
          dataProvider.setCurrentTab(dataProvider.currentTab);
          print(" [DeepLinkDebug TAB]: Kept current tab, triggered rebuild");
        }
      }
    } catch (e) {
      print(" [DeepLinkDebug TAB]: Error setting tab: $e");
    }
  });
}

// Clear any pending navigation operations
void _clearPendingNavigation() {
  try {
    // This helps prevent navigation conflicts by ensuring we start with a clean state
    print(" [DeepLinkDebug CLEAR]: Clearing pending navigation state");
    print(
        " CLEAR: Processing flag is: ${Storage.instance.isProcessingDeepLink}");
  } catch (e) {
    print(" [DeepLinkDebug CLEAR]: Error clearing navigation state: $e");
  }
}

// Clear debounce state after successful navigation
void _clearDebounceState() {
  Future.delayed(const Duration(milliseconds: 500), () {
    Storage.instance.lastProcessedLink = null;
    Storage.instance.lastProcessedTime = null;
    Storage.instance.isProcessingDeepLink = false;
    Storage.instance.setDeepLinkProcessed(false);
    print(" [DeepLinkDebug DEBOUNCE]: State cleared, processing flag reset");
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
