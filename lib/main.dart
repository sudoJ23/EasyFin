import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easyfin/auth/auth_gate.dart';
import 'package:easyfin/commons/my_http_overrides.dart';
import 'package:easyfin/pages/accountdetail.dart';
import 'package:easyfin/pages/contactpage.dart';
import 'package:easyfin/pages/core.dart';
import 'package:easyfin/pages/history.dart';
import 'package:easyfin/pages/home.dart';
import 'package:easyfin/pages/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:easyfin/pages/newcontact.dart';
import 'package:easyfin/pages/pinconfirmation.dart';
import 'package:easyfin/pages/qr.dart';
import 'package:easyfin/pages/receipt.dart';
import 'package:easyfin/pages/signup.dart';
import 'package:easyfin/pages/splash.dart';
import 'package:easyfin/pages/transfer.dart';
import 'firebase_options.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // SocketManager.shared.initSocket();

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  void initState() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: { 
        '/': (context) => SplashScreen(initialization: _initialization),
        '/login':(context) => const LoginPage(),
        '/signup':(context) => const SignUpPage(),
        '/home':(context) => const HomePage(),
        '/account/detail':(context) => const AccountDetail(),
        '/history':(context) => const HistoryPage(),
        '/gate':(context) => const AuthGate(),
        '/core':(context) => const CorePage(),
        '/qr':(context) => const Qr(),
        '/contact':(context) => const ContactPage(),
        '/contact/new':(context) => const NewContactPage(),
        '/transfer':(context) => const TransferPage(),
        '/transfer/confirmation':(context) => const PinConfirmationPage(),
        '/transfer/success':(context) => const Receipt()
      },
    );
  }
}

class MainB extends StatefulWidget {
  const MainB({super.key});

  @override
  State<MainB> createState() => _MainBState();
}

class _MainBState extends State<MainB> {
  @override
  Widget build(BuildContext context) {
    return const AuthGate();
  }
}