import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/theme_data.dart';
import 'package:laathi/router/app_router.dart';
import 'package:laathi/features/login/utils/login_status.dart';
import 'package:sizer/sizer.dart';

//  Future<void> because initializing firebase app
//
//  ProviderScope for using Riverpod state management/s
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Laathi',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        onGenerateRoute: (settings) => generateRoute(settings),
        //  Checking if user has already logged in or not
        home: const LoginStatusChecker(),
      );
    });
  }
}
