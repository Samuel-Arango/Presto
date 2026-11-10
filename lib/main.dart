import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'services/libro_service.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Carga los libros guardados en SQLite antes de mostrar la app.
  try {
    await LibroService.instance.cargarLibros();
  } catch (e) {
    // Si la base de datos falla, la app sigue con los libros de ejemplo.
    debugPrint('No se pudieron cargar los libros: $e');
  }

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: const LoginScreen()));
}