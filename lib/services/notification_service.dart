import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_login/main.dart';
import 'package:flutter/material.dart';

import '../screen/second_screen.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic notifications group',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreateMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );
  }

  static Future<void> _onNotificationCreateMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  static Future<void> _onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
  }

  static Future<void> _onDismissActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification dismissed: ${receivedNotification.id}');
  }

  static Future<void> _onActionReceivedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification action received: ${receivedNotification.payload}');
    if (receivedNotification.payload?['navigate'] == 'true') {
      Navigator.push(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const SecondScreen()),
      );
    }
  }

  static Future<void> createNotification({
    required int id,
    required String title,
    required String body,
    String? summary,
    Map<String, String>? payload,
    ActionType actionType = ActionType.Default,
    NotificationLayout notificationLayout = NotificationLayout.Default,
    NotificationCategory? category,
    String? bigPicture,
    List<NotificationActionButton>? actionButtons,
    bool scheduled = false,
    int? interval,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule:
          scheduled && interval != null
              ? NotificationInterval(
                interval: Duration(seconds: interval),
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true,
              )
              : null,
    );
  }
}
