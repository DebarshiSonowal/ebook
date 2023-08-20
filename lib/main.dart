import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'Constants/theme_data.dart';
import 'Helper/navigator.dart';
import 'Helper/router.dart';
import 'Storage/app_storage.dart';
import 'Storage/data_provider.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Storage.instance.initializeStorage();
  // await Firebase.initializeApp(
  //   // name: "GPlusNewApp",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
              title: 'Tratri',
              theme: AppTheme.getTheme(),
              navigatorKey: Navigation.instance.navigatorKey,
              onGenerateRoute: generateRoute,
            );
          }
      ),
    );
  }
}

