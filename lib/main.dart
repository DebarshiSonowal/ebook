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
    print("🔗 MAIN: Initial link: $initialLink");
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }
  } catch (e) {
    print("🔗 MAIN: Error getting initial link: $e");
  }

  // Listen to all incoming links with enhanced handling
  appLinks.uriLinkStream.listen((uri) {
    print("🔗 MAIN: Received deep link: $uri");
    print("🔗 MAIN: Host: ${uri.host}");
    print("🔗 MAIN: Path: ${uri.path}");
    print("🔗 MAIN: Query: ${uri.query}");
    print("🔗 MAIN: Fragment: ${uri.fragment}");
    _handleDeepLink(uri);
  }, onError: (err) {
    print("🔗 MAIN: Deep link error: $err");
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

// Enhanced deep link handler
void _handleDeepLink(Uri uri) {
  print("🔗 HANDLER: Processing deep link: $uri");

  try {
    // Handle different path patterns
    if (uri.path.startsWith('/link/') || uri.path.startsWith('/app/')) {
      // Extract the actual route from the path
      String actualPath = uri.path.replaceFirst(RegExp(r'^/(link|app)/'), '/');
      Map<String, String> params = uri.queryParameters;

      print("🔗 HANDLER: Extracted path: $actualPath");
      print("🔗 HANDLER: Query params: $params");

      // Navigate based on the extracted path
      _navigateToRoute(actualPath, params);
    } else if (uri.scheme == 'tratri') {
      // Handle custom scheme
      _navigateToRoute(uri.path, uri.queryParameters);
    }
  } catch (e) {
    print("🔗 HANDLER: Error processing deep link: $e");
    // Fallback to main page
    Navigation.instance.navigateAndReplace('/main');
  }
}

void _navigateToRoute(String path, Map<String, String> params) {
  // Add delay to ensure app is fully initialized
  Future.delayed(const Duration(milliseconds: 500), () {
    try {
      switch (path) {
        case '/bookDetails':
          if (params['id'] != null) {
            Navigation.instance.navigate('/bookDetails', args: params['id']!);
          }
          break;
        case '/magazineDetails':
          if (params['id'] != null) {
            Navigation.instance
                .navigate('/magazineDetails', args: params['id']!);
          }
          break;
        case '/categories':
          if (params['type'] != null) {
            Navigation.instance.navigate('/categories', args: params['type']!);
          }
          break;
        case '/bookInfo':
          if (params['id'] != null) {
            Navigation.instance
                .navigate('/bookInfo', args: int.tryParse(params['id']!) ?? 0);
          }
          break;
        default:
          // Navigate to main page for unknown routes
          Navigation.instance.navigateAndReplace('/main');
          break;
      }
    } catch (e) {
      print("🔗 NAVIGATION: Error navigating to route: $e");
      Navigation.instance.navigateAndReplace('/main');
    }
  });
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
