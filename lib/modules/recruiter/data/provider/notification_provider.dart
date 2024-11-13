import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {

  

  List<RemoteMessage> get remoteMessage => _remoteMessage;
  List<RemoteMessage> _remoteMessage = [];
  notificationFromFCM() {
    FirebaseMessaging.onMessage.listen((message) {
      _remoteMessage = [..._remoteMessage, message];
    });
  }

  Future<void> saveNotificationToFirestore(
      Map<String, dynamic> notificationData) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNotificationsFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('notifications').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error retrieving notifications: $e');
      return [];
    }
  }
}
