import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HomeNotification extends StatelessWidget {
  const HomeNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Demo'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OutlinedButton(
            onPressed:
                () => NotificationService.createNotification(
                  id: 1,
                  title: 'Default Notification',
                  body: 'This is a basic notification',
                ),
            child: const Text('Default Notification'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed:
                () => NotificationService.createNotification(
                  id: 2,
                  title: 'Inbox Notification',
                  body: 'This has multiple lines\nLine 2\nLine 3',
                  notificationLayout: NotificationLayout.Inbox,
                ),
            child: const Text('Inbox Style'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed:
                () => NotificationService.createNotification(
                  id: 3,
                  title: 'Progress Notification',
                  body: 'Downloading file...',
                  notificationLayout: NotificationLayout.ProgressBar,
                ),
            child: const Text('Progress Bar'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 4,
                title: 'Message Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.Messaging,
              );
            },
            child: const Text('Message Notification'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed:
                () => NotificationService.createNotification(
                  id: 4,
                  title: 'Big Picture',
                  body: 'Check out this image!',
                  notificationLayout: NotificationLayout.BigPicture,
                  bigPicture: 'https://picsum.photos/600/300',
                ),
            child: const Text('Big Image'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed:
                () => NotificationService.createNotification(
                  id: 5,
                  title: 'Action Buttons',
                  body: 'This notification has actions',
                  payload: {'navigate': 'true'},
                  actionButtons: [
                    NotificationActionButton(key: 'yes', label: 'Yes'),
                    NotificationActionButton(key: 'no', label: 'No'),
                  ],
                ),
            child: const Text('With Actions'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 5,
                title: 'Scheduled Notification',
                body: 'This is the body of the notification',
                scheduled: true,
                interval: 5,
              );
            },
            child: const Text('Scheduled Notification'),
          ),
        ],
      ),
    );
  }
}
