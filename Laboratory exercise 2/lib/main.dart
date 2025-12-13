import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'models/meal.dart';
import 'screens/favorites_screen.dart';
import 'screens/random_meal_screen.dart';
import 'screens/category_list_screen.dart';

import 'services/firebase_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final firebaseService = FirebaseService();

  await firebaseService.initFirebaseMessaging(
    navigatorKey,
    onMessageReceived: (message) {
      if (message.notification != null) {
        print("Foreground notification: "
            "${message.notification!.title} / ${message.notification!.body}");
      }
    },
  );

  runApp(
    MyApp(firebaseService: firebaseService),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService;

  const MyApp({super.key, required this.firebaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "MealDB",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: CategoryListScreen(firebaseService: firebaseService),
      routes: {
        '/favorites': (_) => FavoritesScreen(firebaseService: firebaseService),
        '/randomMeal': (_) => const RandomMealScreen(),
      },
    );
  }
}

