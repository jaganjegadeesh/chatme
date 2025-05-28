// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // Initialize the FlutterLocalNotificationsPlugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     // Permissions
//     await _firebaseMessaging.requestPermission();
//     final settings = await _firebaseMessaging.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     // Token
//     // Initialize local notifications
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Android notification channel
//     createNotificationChannel();

//     // Background
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     // Foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       print('Foreground notification: ${message.notification?.title}');
//       showLocalNotification(message);
//     });
//   }

//   void showLocalNotification(RemoteMessage message) {
//     flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }

//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp(); // required in background
//     print('Background message: ${message.notification?.title}');
//   }

//   void createNotificationChannel() {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // name
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );

//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
// }
