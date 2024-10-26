import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:gyanbuddy/favorite_page_provider.dart';
import 'package:gyanbuddy/landing_page.dart';
import 'package:gyanbuddy/utils/route/routes.dart';
import 'package:gyanbuddy/theme_provider.dart';
import 'package:gyanbuddy/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase configuration
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Global variables
DateTime? currentBackPressTime;
bool visitedGettingStartedPageOnceBool = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();
  visitedGettingStartedPageOnceBool =
      prefs.getBool('visitedGettingStartedPageOnce') ?? false;

  // Avoid initializing Firebase multiple times during hot reload.
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'GyanBuddy',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  FirebaseStorage.instance.setMaxUploadRetryTime(const Duration(seconds: 3));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteScreenProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GyanBuddy',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: visitedGettingStartedPageOnceBool
              ? const Wrapper()
              : const LandingPage(), // Conditional navigation
          // ? const MainHome()
          //   : const LandingPage(), // Conditional navigation

          onGenerateRoute: Routers.generateRoute, // Handle routes dynamically
        );
      },
    );
  }
}
