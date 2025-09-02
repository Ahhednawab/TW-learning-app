import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

// ✅ Background handler must be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Required to use Firebase in background
  print("📩 Background Message Received: ${message.messageId}");
}

// Service class
class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? fcmtoken;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermission();
    _initializeLocalNotifications();
    _configureFCM();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('🚫 Notification permission denied');
    } else {
      print('✅ Notification permission granted');
    }
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  void _configureFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔗 Notification clicked (App opened): ${message.data}");
      _handleNotificationTap(message.data.toString());
    });
  }

  void _handleMessage(RemoteMessage message) {
    print("📩 Foreground Message: ${message.notification?.title}");
    if (message.notification != null) {
      _showNotification(message.notification!, message.data);
    }
  }

  Future<void> _showNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      importance: Importance.low, // Use low to minimize visibility
      priority: Priority.low, // Lower priority
      visibility: NotificationVisibility
          .secret, // Secret means it won't show on the lock screen
      playSound: false, // Make it silent
      enableVibration: false, // Disable vibration
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
      payload: data.isNotEmpty
          ? data['click_action'].toString()
          : null, // Pass data as payload
    );
  }

  void _handleNotificationTap(String? payload) async {
    if (payload != null && payload.startsWith('http')) {
      print("🌍 Opening URL: $payload");
      Uri url = Uri.parse(payload);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("❌ Could not launch $payload");
      }
    } else {
      print("📲 Notification tapped: $payload");
    }
  }

  Future<void> getToken() async {
    String? token = await _messaging.getToken();
    if (token != null) {
      fcmtoken = token;
      print("✅ FCM Token: $fcmtoken");
    } else {
      print("❌ Failed to get FCM token");
    }
    print("🔥 FCM Token: $token");
  }

  Future getFCMToken() async {
    String? token = await _messaging.getToken();
    return token;
  }
}