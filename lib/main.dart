import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'services/libro_service.dart';
import 'services/notificacion_service.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: const LoginScreen()),
  );
}
