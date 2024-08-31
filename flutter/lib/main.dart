import 'package:flutter/material.dart';
import 'package:flutter_application_1/FirebaseMessagingConfig.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingConfig.Run();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    FirebaseMessagingConfig.LocalNotification(
                        title: 'title', body: 'body', payload: {"key": "11"});
                  },
                  child: const Text('Click'),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: FirebaseMessagingConfig.fcmTokenNotifier,
                  builder: (context, token, child) {
                    if (token != null) {
                      controller?.text = token;
                      return TextField(
                        style: const TextStyle(height: 2),
                        controller: controller,
                      );
                    }
                    return const Text('FCM Token: ...');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
