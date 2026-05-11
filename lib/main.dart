import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Updated path
import 'utils/styles.dart';

void main() {
  // Ensure Flutter bindings are initialized for SQLite
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyHisabApp());
}

class MyHisabApp extends StatelessWidget {
  const MyHisabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY HISAB',
      theme: ThemeData(
        // Set the background color to match your Neumorphic design
        scaffoldBackgroundColor: NeumorphicColors.background,
        useMaterial3: true,
      ),
      // This makes your Login Screen the first page
      home: const LoginScreen(),
    );
  }
}
