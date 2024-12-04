import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  
  /// Update the iOS foreground notification presentation options to allow heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    
  }
}


FirebaseMessaging messaging = FirebaseMessaging.instance;
void setupFirebaseMessage() async {
  await FirebaseMessaging.instance.subscribeToTopic('all');
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await messaging.setAutoInitEnabled(true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  FirebaseMessaging.onMessage.listen(showFlutterNotification);
}

Future<String?> getToken() async {
  //get token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log("fcmToken: $fcmToken");
  final iosToken = await FirebaseMessaging.instance.getAPNSToken();

  if (Platform.isAndroid) {
    return fcmToken;
  } else if (Platform.isIOS) {
    return iosToken;
  } else {
    return 'Unknown device, no token';
  }
}
