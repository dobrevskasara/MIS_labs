import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/meal.dart';
import 'screens/favorites_screen.dart';
import 'screens/random_meal_screen.dart';
import 'screens/category_list_screen.dart';

import 'services/firebase_service.dart';
import 'services/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  await NotificationService.showTestNotification();
  final firebaseService = FirebaseService();

  await firebaseService.initFirebaseMessaging(
    navigatorKey,
    onMessageReceived: (message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              '${message.notification!.title ?? ''}: '
                  '${message.notification!.body ?? ''}',
            ),
          ),
        );
      }
    },
  );

  runApp(MyApp(firebaseService: firebaseService));
}

class MyApp extends StatefulWidget {
  final FirebaseService firebaseService;

  const MyApp({super.key, required this.firebaseService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MealDB Рецепти',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: CategoryListScreen(firebaseService: widget.firebaseService),
      routes: {
        '/favorites': (_) =>
            FavoritesScreen(firebaseService: widget.firebaseService),
        '/randomMeal': (_) => const RandomMealScreen(),
      },
    );
  }
}
