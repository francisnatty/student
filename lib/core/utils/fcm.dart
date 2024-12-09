import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/features/chats/screens/incomming_call_screen.dart';
import 'package:student_centric_app/features/chats/screens/incomming_video_call_screen.dart';

class FCM {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String?> getDeviceFCMToken() async {
    NotificationSettings settings = await _messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return await _messaging.getToken();
    } else {
      return "";
    }
  }

  static Future<void> listenForTokenUpdates() async {
    // listens and updates firebase token
    _messaging.onTokenRefresh.listen((event) {
      // calls the token update use case here
      // check if local token is not equal to new token before saving
    });
  }

  static void listenForForegroundMessages(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) async {
      if (event.notification != null) {
        print("Foreground Message Detected");

        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: event.notification?.title,
            body: event.notification?.body,
            icon: 'resource://drawable/logo',
          ),
        );

        print("Event title: ${event.notification?.title}");

        if (event.notification?.title == "Incoming Call") {
          context.push(
            IncomingCallScreen(
                callerId: event.notification?.title??"Samuel Salami", channelName: "Caller123"),
          );
        } else if (event.notification?.title == "Incomming Video Call") {
          context.push(
            IncomingVideoCallScreen(
                callerId: event.notification?.title??"Samuel Salami", channelName: "Caller123"),
          );
        }
      }
    });
  }

  static Future<void> listenForBackgroundMessages() async {
    print("On Background");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage msg) async {
    print('Handling a background message: ${msg.messageId}');
  }
}
