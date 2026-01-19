import 'package:flutter/material.dart';

import 'views/home_view.dart';
import 'services/tostore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ToStoreService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToStore Chat Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeView(),
    );
  }
}
