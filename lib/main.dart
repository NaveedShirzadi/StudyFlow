import 'package:flutter/material.dart';
import 'package:studyflow/MenuUI/post_login_menu_ui.dart';
import 'MenuUI/login_page_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
        ? const LoginPage()
        : const PostLoginMenuUI(),
    );
  }
}