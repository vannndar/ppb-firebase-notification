import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  final String groupId;

  TodoScreen({required this.groupId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _taskController = TextEditingController();
  final _taskDueDateController = TextEditingController();

  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('tasks').add({
        'task': _taskController.text,
        'groupId': widget.groupId,
        'createdAt': Timestamp.now(),
        'completed': false,
        'dueDate': DateTime.now().add(
          Duration(minutes: int.parse(_taskDueDateController.text)),
        ),
      });

      // Schedule notification
      DateTime dueDate = DateTime.now().add(
        Duration(minutes: int.parse(_taskDueDateController.text)),
      );
      _sendNotification(dueDate, _taskController.text);

      _taskController.clear();
    }
  }

  // Method to send notification
  Future<void> _sendNotification(DateTime dueDate, String taskName) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'basic_channel',
        title: 'Task Reminder',
        body: 'Task "$taskName" is due soon.',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        year: dueDate.year,
        month: dueDate.month,
        day: dueDate.day,
        hour: dueDate.hour,
        minute: dueDate.minute,
        preciseAlarm: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Add Task',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _taskDueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () => _addTask(),
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .where('groupId', isEqualTo: widget.groupId)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final task = snapshot.data!.docs[index];
                          final taskName = task['task'];
                          final dueDate =
                              (task['dueDate'] as Timestamp).toDate();
                          final isOverdue = dueDate.isBefore(DateTime.now());
                          if (isOverdue) {
                            // Show overdue tasks in red
                            return ListTile(
                              title: Text(
                                taskName,
                                style: TextStyle(
                                  color: isOverdue ? Colors.red : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isOverdue
                                    ? 'Overdue by ${DateTime.now().difference(dueDate).inMinutes} minutes'
                                    : 'Due in ${dueDate.difference(DateTime.now()).inMinutes} minutes',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(task.id)
                                      .delete();
                                },
                              ),
                              onTap: () {
                                // Optional: Show a notification when the task is tapped
                                if (isOverdue) {
                                  AwesomeNotifications().createNotification(
                                    content: NotificationContent(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      channelKey: 'basic_channel',
                                      title: 'Overdue Task',
                                      body: 'The task "$taskName" is overdue!',
                                    ),
                                  );
                                }
                              },
                            );
                          }
                          return ListTile(
                            title: Text(task['task']),
                            subtitle: Text(
                              'Due in ${dueDate.difference(DateTime.now()).inMinutes} minutes',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(task.id)
                                    .delete();
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
