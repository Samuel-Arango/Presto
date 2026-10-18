import 'package:flutter/material.dart';

import '../views/loan_registration.dart';
import '../views/new_book.dart';

// Menú lateral de la app: permite ir a las pantallas principales desde el Home.
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  // Cierra el menú y abre la pantalla elegida.
  void _abrirPantalla(BuildContext context, Widget pantalla) {
    final navegador = Navigator.of(context);
    navegador.pop();
    navegador.push(MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado con los mismos colores del degradado de la app.
          Container(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE8F1FF), Color(0xFFC9B6FF)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.menu_book, size: 40),
                SizedBox(height: 8),
                Text(
                  'PRESTO',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Préstamos bibliotecarios',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // Ya estamos en el Home, por eso solo se cierra el menú.
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.library_add),
            title: const Text('Nuevo libro'),
            onTap: () => _abrirPantalla(context, const NewBook()),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Registro de préstamos'),
            onTap: () => _abrirPantalla(context, const LoanRegistration()),
          ),
        ],
      ),
    );
  }
}
