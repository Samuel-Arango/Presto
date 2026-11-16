import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../layouts/presto_title.dart';
import 'login_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F1FF),
              Color(0xFFD6E4FF),
              Color(0xFFD6E4FF),
              Color(0xFFE8DFFF),
            ],
          ),
        ),
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: PrestoTitle()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: LoginPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
