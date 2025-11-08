import 'package:candc_demo_flutter/screen/login_screen.dart';
import 'package:candc_demo_flutter/screen/my_task_screen/my_task_screen.dart';
import 'package:candc_demo_flutter/utils/notification_helper.dart';
import 'package:candc_demo_flutter/utils/shared_pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefHelper.init();
  await NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: SharedPrefHelper().getBool('isUserLoggedIn')
          ? MyTaskScreen()
          : LoginScreen(),
    );
  }
}
