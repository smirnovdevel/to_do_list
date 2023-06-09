import 'package:flutter/material.dart';
import 'package:to_do_list/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO лист',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.grey.shade100),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
