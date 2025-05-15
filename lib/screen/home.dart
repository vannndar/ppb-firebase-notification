import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/screen/todo.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groupNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String userId;

  void logout() async {
    await _auth.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'login');
  }

  Future<void> _addGroup() async {
    if (_groupNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('groups').add({
        'groupName': _groupNameController.text,
        'users': [userId],
        'createdAt': Timestamp.now(),
      });
      _groupNameController.clear();
    }
  }

  Future<void> _joinGroup(String groupId) async {
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'users': FieldValue.arrayUnion([userId]),
    });
    final groupName = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get()
        .then((value) => value['groupName']);
    _sendNotification(DateTime.now(), 'Joined $groupName.');
  }

  Future<void> _leaveGroup(String groupId) async {
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'users': FieldValue.arrayRemove([userId]),
    });
    // get groupname from groupId
    final groupName = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get()
        .then((value) => value['groupName']);
    _sendNotification(DateTime.now(), 'Left $groupName.');
  }

  Future<void> _sendNotification(DateTime dueDate, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'basic_channel',
        title: 'Group Notification',
        body: body,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          userId = user.uid;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Todo List'),
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.logout), onPressed: logout),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  TextField(
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addGroup,
                    child: const Text('Create Group'),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('groups')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final groups = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final groupName = groups[index]['groupName'];
                            final groupId = groups[index].id;
                            final users = List<String>.from(
                              groups[index]['users'],
                            );

                            final isMember = users.contains(userId);

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              color: Colors.grey[300],
                              child: ListTile(
                                title: Text(groupName),
                                subtitle: Text('Users: ${users.length}'),
                                trailing:
                                    isMember
                                        ? IconButton(
                                          icon: Icon(Icons.exit_to_app),
                                          color: Colors.red,
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () => _leaveGroup(groupId),
                                        )
                                        : IconButton(
                                          icon: Icon(Icons.add),
                                          color: Colors.white,
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
                                          onPressed: () => _joinGroup(groupId),
                                        ),
                                onTap: () {
                                  if (!isMember) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Join Group'),
                                            content: Text(
                                              'You need to join this group $groupName to access the tasks.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => TodoScreen(groupId: groupId),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No groups available.'));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
