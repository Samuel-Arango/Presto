import 'package:flutter/material.dart';

// Barra superior reutilizable: se escribe una sola vez y se usa en varias
// pantallas, en lugar de repetir el mismo AppBar en cada archivo.
// Implementa PreferredSizeWidget para poder usarse en el parámetro appBar
// del Scaffold.
class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  // Texto que se muestra en el centro de la barra.
  final String titulo;

  const BarraSuperior({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Flecha para volver a la pantalla anterior.
      leading: IconButton(
        icon: const Icon(Icons.navigate_before),
        tooltip: 'Volver',
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(titulo),
      centerTitle: true,
    );
  }

  // Altura que ocupa la barra: la estándar de Flutter.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
