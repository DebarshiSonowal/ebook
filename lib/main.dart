import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'Constants/theme_data.dart';
import 'Helper/navigator.dart';
import 'Helper/router.dart';
import 'Storage/app_storage.dart';
import 'Storage/data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.instance.initializeStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>DataProvider(),
      child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ebook',
              theme: AppTheme.getTheme(),
              navigatorKey: Navigation.instance.navigatorKey,
              onGenerateRoute: generateRoute,
            );
          }
      ),
    );
  }
}

