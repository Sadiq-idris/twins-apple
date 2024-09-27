import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';

class MyCloudMessage {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  Future<void> initNotification() async {
    _firebaseMessaging.requestPermission();
    // getting device fcm token
    String? fcmToken = await _firebaseMessaging.getToken();
    // print("----------TOKEN: $fcmToken");

    await initPushNotification();
  }

  Future<void> subscribeTopic() async {
    const topic = "icaptain";
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> initPushNotification() async {
    // FirebaseMessaging.onBackgroundMessage(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      print("working");
      final data = message.data;
      print(data);
      showSimpleNotification(
        Text(data["title"]),
        background: Colors.white,
        leading: const Icon(Icons.chat),
        subtitle: Text(data["body"]),
      );
      
    });
    _firebaseMessaging.getInitialMessage().then(handleMessage);
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message != null) {
      final notificationMessage = message.data;
      print("Notification-----------:$notificationMessage");
      // showSimpleNotification(
      //   const Text("New Notification"),
      //   subtitle: Text(notificationMessage["notification"]["title"]),
      // );
    }
  }
}
