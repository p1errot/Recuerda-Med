import 'package:flutter/material.dart';
import 'package:recuerdamed/config/theme/app_theme.dart';
import 'package:recuerdamed/presentation/Screens/login/login_screen.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme(selectColor: 0).theme(),
      title: 'RecuerdaMed',
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
