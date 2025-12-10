import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initFirebaseMessaging(GlobalKey<NavigatorState> navigatorKey, {
    Function(RemoteMessage)? onMessageReceived,
  }) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(
            'Notification Title: ${message.notification!.title}, Body: ${message
                .notification!.body}');
        if (onMessageReceived != null) onMessageReceived(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/randomMeal');
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      navigatorKey.currentState?.pushNamed('/randomMeal');
    }
  }

  Stream<List<Meal>> getFavoritesStream() {
    return _firestore.collection('favorites').snapshots().map((snapshot) {
      print('Favorites loaded from Firebase: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) => Meal.fromJson(doc.data())).toList();
    });
  }

  Future<void> addFavorite(Meal meal) async {
    await _firestore.collection('favorites').doc(meal.idMeal).set(
        meal.toJson());
  }

  Future<void> removeFavorite(String mealId) async {
    await _firestore.collection('favorites').doc(mealId).delete();
  }

  Future<bool> isFavorite(String mealId) async {
    final doc = await _firestore.collection('favorites').doc(mealId).get();
    return doc.exists;
  }
}