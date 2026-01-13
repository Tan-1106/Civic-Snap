import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final GlobalKey<NavigatorState> _navigatorKey;

  NotificationService(
    this._fcm,
    this._firestore,
    this._auth,
    this._localNotifications,
    this._navigatorKey,
  );

  // Define Android Notification Channel
  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  // Save FCM Token to Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({'fcmToken': token});
    }
  }

  // Initialize Local Notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_androidChannel);
  }

  // Initialize Notifications
  Future<void> initNotifications() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _initLocalNotifications();

      String? token = await _fcm.getToken();
      if (token != null && _auth.currentUser != null) {
        await _saveTokenToFirestore(token);
        _fcm.onTokenRefresh.listen(_saveTokenToFirestore);
      }
    }
  }

  void setupInteractions() async {
    // 1. Terminated
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleTerminatedMessage(initialMessage);
    }

    // 2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _showLocalNotification(notification, android, message.data);
      }
    });

    // 3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message);
    });
  }

  void _handleNavigation(RemoteMessage message) {
    final context = _navigatorKey.currentState?.context;
    if (context == null) return;

    final String currentLocation = GoRouterState.of(context).uri.toString();
    if (currentLocation != '/sign-in' && currentLocation != '/sign-up' && currentLocation != '/forgot-password') {
      context.go('/user-profile');
    } else {
      context.go('/sign-in');
    }
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    final context = _navigatorKey.currentState?.context;
    if (context == null) return;
    context.go('/sign-in');
  }

  void _showLocalNotification(RemoteNotification notification, AndroidNotification android, Map<String, dynamic> data) {
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }
}
