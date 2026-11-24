import 'package:flutter/material.dart';
import 'home/home_tab.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '국립한국교통대학교',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA3162B)),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F7FA), foregroundColor: Color(0xFF181B22), centerTitle: false),
    ),
    home: const HomeTab(),
  );
}
