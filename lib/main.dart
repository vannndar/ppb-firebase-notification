import 'screen/account.dart';
import 'screen/home.dart';
import 'screen/home_screen.dart';
import 'screen/login.dart';
import 'screen/register.dart';
import 'screen/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_login/services/notification_service.dart';

import 'screen/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      routes: {
        'home': (context) => const HomeScreen(),
        'todo':
            (context) => TodoScreen(
              groupId: ModalRoute.of(context)?.settings.arguments as String,
            ),
        'account': (context) => const AccountScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home_notification': (context) => const HomeNotification(),
        'second': (context) => const SecondScreen(),
      },
    );
  }
}
